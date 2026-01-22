#!/usr/bin/env bash
set -euo pipefail

# This script is intended to run INSIDE the qa_automation container.
# It assumes mysql/mongodb are already started by docker-compose and reachable via service DNS names.

cd /app

LOCK_FILE="/tmp/qa_automation.lock"
exec 200>"$LOCK_FILE"
flock -n 200 || { echo "❌ QA already running (lock: $LOCK_FILE)"; exit 2; }

REPORTS_DIR="${REPORTS_DIR:-/reports}"
mkdir -p "${REPORTS_DIR}/formy" "${REPORTS_DIR}/databaseUsage" "${REPORTS_DIR}/gatling" "${REPORTS_DIR}/nested"

# ✅ Allure results (one folder per run)
rm -rf "${REPORTS_DIR}/allure-results" || true
mkdir -p "${REPORTS_DIR}/allure-results"

# ---- helpers ----
wait_for_tcp() {
  local host="$1"
  local port="$2"
  local name="${3:-$host:$port}"
  local tries="${4:-60}"
  local sleep_s="${5:-2}"

  echo "⏳ Waiting for ${name} (${host}:${port})..."
  for i in $(seq 1 "$tries"); do
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

# ---- DB endpoints from env (override if needed) ----
MYSQL_HOST="${MYSQL_HOST:-mysql}"
MYSQL_PORT="${MYSQL_PORT:-3306}"
MONGO_HOST="${MONGO_HOST:-mongodb}"
MONGO_PORT="${MONGO_PORT:-27017}"

wait_for_tcp "$MYSQL_HOST" "$MYSQL_PORT" "MySQL"
wait_for_tcp "$MONGO_HOST" "$MONGO_PORT" "MongoDB"

# ---- run suites ----
rc=0

# ✅ Make sure all suites write Allure into the same base (subfolders are handled in run_* scripts)
export ALLURE_RESULTS_DIR="${REPORTS_DIR}/allure-results"

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

# ---- collect reports into $REPORTS_DIR ----
# NOTE: cucumber plugins already write reports directly into /reports (via absolute paths in CucumberOptions).
# We still copy some legacy artifacts from target/ for convenience.

# Formy
copy_if_exists "/app/formyProject/target/cucumber/cucumber.json" "${REPORTS_DIR}/formy/cucumber.json"
copy_if_exists "/app/formyProject/target/cucumber.html" "${REPORTS_DIR}/formy/cucumber.html"
copy_if_exists "/app/formyProject/target/cucumber-html-report" "${REPORTS_DIR}/formy/cucumber-html-report"
copy_if_exists "/app/formyProject/target/surefire-reports" "${REPORTS_DIR}/formy/surefire-reports"
# If something still writes TEST-*.xml into target:
copy_if_exists "/app/formyProject/target/TEST-*.xml" "${REPORTS_DIR}/formy/" || true

# DatabaseUsage
copy_if_exists "/app/databaseUsage/target/cucumber/cucumber.json" "${REPORTS_DIR}/databaseUsage/cucumber.json"
copy_if_exists "/app/databaseUsage/target/cucumber.html" "${REPORTS_DIR}/databaseUsage/cucumber.html"
copy_if_exists "/app/databaseUsage/target/cucumber-html-report" "${REPORTS_DIR}/databaseUsage/cucumber-html-report"
copy_if_exists "/app/databaseUsage/target/surefire-reports" "${REPORTS_DIR}/databaseUsage/surefire-reports"
copy_if_exists "/app/databaseUsage/target/TEST-*.xml" "${REPORTS_DIR}/databaseUsage/" || true

# Gatling
copy_if_exists "/app/restfulBookerLoad/target/gatling" "${REPORTS_DIR}/gatling"
if [[ -d "${REPORTS_DIR}/gatling" && ! -d "${REPORTS_DIR}/gatling/latest" ]]; then
  latest_dir="$(ls -1dt "${REPORTS_DIR}/gatling"/*/ 2>/dev/null | head -n 1 || true)"
  if [[ -n "${latest_dir:-}" ]]; then
    ln -s "$(basename "$latest_dir")" "${REPORTS_DIR}/gatling/latest" 2>/dev/null || true
  fi
fi

# Nested (if you generate it somewhere)
copy_if_exists "/app/reports/nested" "${REPORTS_DIR}/nested" || true

# ---- dashboard ----
echo "▶ Generating QA Dashboard (${REPORTS_DIR}/index.html)..."
cat > "${REPORTS_DIR}/index.html" <<'HTML'
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
      <li>JSON: <code>formy/cucumber.json</code></li>
      <li>JUnit XML: <code>formy/TEST-formy.xml</code></li>
      <li>Allure Results: <code>allure-results/</code></li>
    </ul>
  </div>

  <div class="card">
    <h2>DB tests</h2>
    <ul>
      <li>HTML: <a href="databaseUsage/cucumber.html">open</a></li>
      <li>JSON: <code>databaseUsage/cucumber.json</code></li>
      <li>JUnit XML: <code>databaseUsage/TEST-databaseUsage.xml</code></li>
      <li>Allure Results: <code>allure-results/</code></li>
    </ul>
  </div>

  <div class="card">
    <h2>Load tests (Gatling)</h2>
    <ul>
      <li>HTML: <a href="gatling/latest/index.html">open</a></li>
    </ul>
  </div>
</body>
</html>
HTML
echo "✔ ${REPORTS_DIR}/index.html generated"

echo "▶ Reports directory listing:"
ls -la "${REPORTS_DIR}" || true

echo "▶ Allure results listing (first 200 files):"
find "${REPORTS_DIR}/allure-results" -type f 2>/dev/null | head -n 200 || true

# ---- contract: at least some reports should exist ----
if [[ ! -f "${REPORTS_DIR}/formy/cucumber.json" \
   && ! -f "${REPORTS_DIR}/databaseUsage/cucumber.json" \
   && ! -f "${REPORTS_DIR}/gatling/latest/index.html" ]]; then
  echo "❌ No reports generated at all — failing build"
  exit 10
fi

# ✅ contract: allure-results must contain at least one file (not just empty dirs)
if ! find "${REPORTS_DIR}/allure-results" -type f -print -quit 2>/dev/null | grep -q .; then
  echo "❌ Allure results are missing/empty (${REPORTS_DIR}/allure-results) — failing build as pipeline broken"
  exit 12
fi

if [[ "$rc" != "0" ]]; then
  echo "❌ QA suites failed (rc=$rc) — failing build"
  exit 11
fi

echo "✔ All QA test suites finished successfully"