#!/usr/bin/env bash
# run_all_qa.sh
set -euo pipefail

# Intended to run INSIDE the qa_automation container.
cd /app

REPORTS_DIR="${REPORTS_DIR:-/reports}"
RUNS_DIR="${REPORTS_DIR}/runs"

# Prefer lock inside /reports so it is shared across container restarts/workspaces
LOCK_FILE="${REPORTS_DIR}/.qa_automation.lock"
mkdir -p "${RUNS_DIR}"
exec 200>"$LOCK_FILE"
flock -n 200 || { echo "❌ QA already running (lock: $LOCK_FILE)"; exit 2; }

# Run identity:
# - Prefer RUN_ID from env (can be injected by CI)
# - Else generate UTC timestamp id
RUN_ID="${RUN_ID:-$(date -u +%Y%m%d-%H%M%S)}"
RUN_DIR="${RUNS_DIR}/${RUN_ID}"

# We store everything ONLY inside runs/<RUN_ID>
mkdir -p \
  "${RUN_DIR}/formy" \
  "${RUN_DIR}/databaseUsage" \
  "${RUN_DIR}/gatling" \
  "${RUN_DIR}/nested" \
  "${RUN_DIR}/allure-results" \
  "${RUN_DIR}/allure-report"

# ---- helpers ----
wait_for_tcp() {
  local host="$1"
  local port="$2"
  local name="${3:-$host:$port}"
  local tries="${4:-60}"
  local sleep_s="${5:-2}"

  echo "⏳ Waiting for ${name} (${host}:${port})..."
  for _ in $(seq 1 "$tries"); do
    if (echo >/dev/tcp/"$host"/"$port") >/dev/null 2>&1; then
      echo "✅ ${name} is reachable"
      return 0
    fi
    sleep "$sleep_s"
  done
  echo "❌ Timeout waiting for ${name} (${host}:${port})"
  return 1
}

copy_if_exists() {
  local src="$1"
  local dst="$2"
  if [[ -e "$src" ]]; then
    mkdir -p "$(dirname "$dst")"
    rm -rf "$dst" 2>/dev/null || true
    cp -a "$src" "$dst"
  fi
}

run_with_timeout() {
  local name="$1"
  local t="$2"
  shift 2
  if command -v timeout >/dev/null 2>&1; then
    echo "⏱  Timeout for ${name}: ${t}"
    timeout --preserve-status "$t" "$@"
  else
    echo "⚠️  'timeout' not found; running ${name} without timeout"
    "$@"
  fi
}

# Atomic write helper (same filesystem)
atomic_write_file() {
  local path="$1"
  local content="$2"
  local tmp
  tmp="$(mktemp "${path}.tmp.XXXXXX")"
  printf "%s" "$content" > "$tmp"
  mv -f "$tmp" "$path"
}

# Symlink helper (atomic replace)
atomic_symlink() {
  local target="$1"
  local linkpath="$2"
  ln -sfn "$target" "$linkpath"
}

# ---- DB endpoints from env (override if needed) ----
MYSQL_HOST="${MYSQL_HOST:-mysql}"
MYSQL_PORT="${MYSQL_PORT:-3306}"
MONGO_HOST="${MONGO_HOST:-mongodb}"
MONGO_PORT="${MONGO_PORT:-27017}"

wait_for_tcp "$MYSQL_HOST" "$MYSQL_PORT" "MySQL"
wait_for_tcp "$MONGO_HOST" "$MONGO_PORT" "MongoDB"

# ---- run suites ----
rc=0

# ✅ All suites must write Allure into THIS run folder
export ALLURE_RESULTS_DIR="${RUN_DIR}/allure-results"

echo "▶ RUN_ID=${RUN_ID}"
echo "▶ RUN_DIR=${RUN_DIR}"
echo "▶ ALLURE_RESULTS_DIR=${ALLURE_RESULTS_DIR}"

echo "▶ Running DB tests..."
set +e
run_with_timeout "DB tests" "25m" /app/tools/run_database.sh
db_rc=$?
set -e
echo "✔ DB tests finished with rc=$db_rc"
if [[ "$db_rc" != "0" ]]; then rc="$db_rc"; fi

echo "▶ Running UI tests (Formy)..."
set +e
run_with_timeout "UI tests (Formy)" "25m" /app/tools/run_formy.sh
ui_rc=$?
set -e
echo "✔ UI tests finished with rc=$ui_rc"
if [[ "$ui_rc" != "0" && "$rc" == "0" ]]; then rc="$ui_rc"; fi

echo "▶ Running load tests (Gatling)..."
set +e
run_with_timeout "Load tests (Gatling)" "25m" /app/tools/run_gatling.sh
gat_rc=$?
set -e
echo "✔ Gatling finished with rc=$gat_rc"
if [[ "$gat_rc" != "0" && "$rc" == "0" ]]; then rc="$gat_rc"; fi

# ---- collect reports into RUN_DIR ----

# Formy
copy_if_exists "/app/formyProject/target/cucumber/cucumber.json" "${RUN_DIR}/formy/cucumber.json"
copy_if_exists "/app/formyProject/target/cucumber.html" "${RUN_DIR}/formy/cucumber.html"
copy_if_exists "/app/formyProject/target/cucumber-html-report" "${RUN_DIR}/formy/cucumber-html-report"
copy_if_exists "/app/formyProject/target/surefire-reports" "${RUN_DIR}/formy/surefire-reports"
copy_if_exists "/app/formyProject/target/TEST-*.xml" "${RUN_DIR}/formy/" || true

# DatabaseUsage
copy_if_exists "/app/databaseUsage/target/cucumber/cucumber.json" "${RUN_DIR}/databaseUsage/cucumber.json"
copy_if_exists "/app/databaseUsage/target/cucumber.html" "${RUN_DIR}/databaseUsage/cucumber.html"
copy_if_exists "/app/databaseUsage/target/cucumber-html-report" "${RUN_DIR}/databaseUsage/cucumber-html-report"
copy_if_exists "/app/databaseUsage/target/surefire-reports" "${RUN_DIR}/databaseUsage/surefire-reports"
copy_if_exists "/app/databaseUsage/target/TEST-*.xml" "${RUN_DIR}/databaseUsage/" || true

# Gatling
copy_if_exists "/reports/gatling/latest" "${RUN_DIR}/gatling/latest"

# Ensure RUN_DIR/gatling/latest -> newest simulation dir under RUN_DIR/gatling/
if [[ -d "${RUN_DIR}/gatling" && ! -d "${RUN_DIR}/gatling/latest" ]]; then
  rm -f "${RUN_DIR}/gatling/latest" || true
  latest_dir="$(ls -1dt "${RUN_DIR}/gatling"/*/ 2>/dev/null | head -n 1 || true)"
  if [[ -n "${latest_dir:-}" ]]; then
    ln -s "$(basename "$latest_dir")" "${RUN_DIR}/gatling/latest"
  fi
fi

# Nested (generated from Allure results)
echo "▶ Generating nested data.json (${RUN_DIR}/nested/data.json)..."
export NESTED_OUT_JSON="${RUN_DIR}/nested/data.json"
export ALLURE_UI_RESULTS_DIR="${RUN_DIR}/allure-results/formy"
export ALLURE_DB_RESULTS_DIR="${RUN_DIR}/allure-results/databaseUsage"
export RUN_ID
if ! command -v javac >/dev/null 2>&1; then
  echo "❌ javac not found; cannot generate nested data.json"
  exit 14
fi
if ! command -v java >/dev/null 2>&1; then
  echo "❌ java not found; cannot generate nested data.json"
  exit 14
fi
javac -cp /app /app/tools/NestedReportGenerator.java
java -cp /app tools.NestedReportGenerator

# ---- generate Allure HTML report (CI only) ----
echo "▶ Generating Allure HTML report (${RUN_DIR}/allure-report)..."
rm -rf "${RUN_DIR}/allure-report"/*
allure generate \
  "${RUN_DIR}/allure-results/formy" \
  "${RUN_DIR}/allure-results/databaseUsage" \
  -o "${RUN_DIR}/allure-report" --clean

if [[ ! -f "${RUN_DIR}/allure-report/index.html" ]]; then
  echo "❌ Allure report was not generated (missing allure-report/index.html) — failing build"
  exit 12
fi

if [[ ! -f "${RUN_DIR}/allure-report/data/summary.json" \
   || ! -f "${RUN_DIR}/allure-report/data/test-cases.json" \
   || ! -f "${RUN_DIR}/allure-report/data/suites.json" ]]; then
  echo "❌ Allure report incomplete (missing summary/test-cases/suites) — failing build"
  exit 13
fi
echo "✔ Allure report generated"

# ---- dashboard (per-run) ----
echo "▶ Generating QA Dashboard (${RUN_DIR}/index.html)..."
cat > "${RUN_DIR}/index.html" <<'HTML'
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8"/>
  <title>QA Dashboard</title>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <style>
    body { font-family: system-ui, -apple-system, Segoe UI, Roboto, Arial; margin: 24px; }
    .card { border: 1px solid #ddd; border-radius: 12px; padding: 16px; margin: 12px 0; }
    a { text-decoration: none; }
    code { background: #f6f6f6; padding: 2px 6px; border-radius: 6px; }
  </style>
</head>
<body>
  <h1>QA Dashboard</h1>

  <div class="card">
    <h2>UI tests (Formy)</h2>
    <ul>
      <li>HTML: <a href="formy/cucumber.html">open</a></li>
      <li>HTML (Cucumber Report): <a href="formy/cucumber-html-report/index.html">open</a></li>
      <li>JSON: <code>formy/cucumber.json</code></li>
      <li>JUnit XML: <code>formy/surefire-reports/</code></li>
    </ul>
  </div>

  <div class="card">
    <h2>DB tests</h2>
    <ul>
      <li>HTML: <a href="databaseUsage/cucumber.html">open</a></li>
      <li>HTML (Cucumber Report): <a href="databaseUsage/cucumber-html-report/index.html">open</a></li>
      <li>JSON: <code>databaseUsage/cucumber.json</code></li>
      <li>JUnit XML: <code>databaseUsage/surefire-reports/</code></li>
    </ul>
  </div>

  <div class="card">
    <h2>Load tests (Gatling)</h2>
    <ul>
      <li>HTML: <a href="gatling/latest/index.html">open</a></li>
    </ul>
  </div>

  <div class="card">
    <h2>Allure</h2>
    <ul>
      <li>Allure Results: <code>allure-results/</code></li>
      <li>Open Allure tab in Jenkins (left menu)</li>
    </ul>
  </div>
</body>
</html>
HTML
echo "✔ ${RUN_DIR}/index.html generated"

# ---- contract checks (before moving pointers) ----
if [[ ! -f "${RUN_DIR}/formy/cucumber.json" \
   && ! -f "${RUN_DIR}/databaseUsage/cucumber.json" \
   && ! -f "${RUN_DIR}/gatling/latest/index.html" ]]; then
  echo "❌ No reports generated at all — failing build"
  exit 10
fi

if ! find "${RUN_DIR}/allure-results" -type f -print -quit 2>/dev/null | grep -q .; then
  echo "❌ Allure results are missing/empty (${RUN_DIR}/allure-results) — failing build as pipeline broken"
  exit 12
fi

# ---- update pointers (single source of truth, atomic) ----
# IMPORTANT: link to RUN_ID path, not to an absolute dir, to avoid "symlink-to-symlink" chains.
atomic_write_file "${REPORTS_DIR}/LATEST" "${RUN_ID}"

atomic_symlink "runs/${RUN_ID}" "${REPORTS_DIR}/current"

# Current-view symlinks (always point to "current/...", never to absolute RUN_DIR)
atomic_symlink "current/index.html" "${REPORTS_DIR}/index.html"
atomic_symlink "current/formy" "${REPORTS_DIR}/formy"
atomic_symlink "current/databaseUsage" "${REPORTS_DIR}/databaseUsage"
atomic_symlink "current/gatling" "${REPORTS_DIR}/gatling"
atomic_symlink "current/allure-results" "${REPORTS_DIR}/allure-results"
atomic_symlink "current/allure-report" "${REPORTS_DIR}/allure-report"

echo "🧷 Updated pointers:"
echo " - LATEST=${REPORTS_DIR}/LATEST -> ${RUN_ID}"
echo " - current=${REPORTS_DIR}/current -> runs/${RUN_ID}"

echo "▶ RUN_DIR listing:"
ls -la "${RUN_DIR}" || true

echo "▶ Allure results listing (first 200 files):"
find "${RUN_DIR}/allure-results" -type f 2>/dev/null | head -n 200 || true

# If any suite failed — fail build (reports already collected)
if [[ "$rc" != "0" ]]; then
  echo "❌ QA suites failed (rc=$rc) — failing build"
  exit 11
fi

echo "✔ All QA test suites finished successfully"
