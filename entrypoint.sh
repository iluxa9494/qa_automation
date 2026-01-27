#!/usr/bin/env bash
# entrypoint.sh
set -euo pipefail

REPORTS_DIR="${REPORTS_DIR:-/reports}"

mkdir -p \
  "${REPORTS_DIR}/formy" \
  "${REPORTS_DIR}/databaseUsage" \
  "${REPORTS_DIR}/gatling" \
  "${REPORTS_DIR}/nested" \
  "${REPORTS_DIR}/allure-results" \
  "${REPORTS_DIR}/allure-report"

echo "▶ QA container runner started"
echo "▶ Reports dir: ${REPORTS_DIR}"
echo "▶ JAVA_OPTS: ${JAVA_OPTS:-<empty>}"

# Make sure all suites write Allure into the same base dir
export ALLURE_RESULTS_DIR="${ALLURE_RESULTS_DIR:-${REPORTS_DIR}/allure-results}"

rc_formy=0
rc_db=0
rc_gatling=0

run_suite() {
  local name="$1"
  local cmd="$2"

  echo "▶ Running suite: ${name}"
  set +e
  bash -lc "${cmd}"
  local rc=$?
  set -e

  if [[ "${rc}" -ne 0 ]]; then
    echo "❌ Suite '${name}' failed with rc=${rc}"
  else
    echo "✔ Suite '${name}' finished successfully"
  fi

  return "${rc}"
}

# 1) UI tests (Formy)
if run_suite "formy" "/app/tools/run_formy.sh"; then
  rc_formy=0
else
  rc_formy=$?
fi

# 2) DB tests
if run_suite "databaseUsage" "/app/tools/run_database.sh"; then
  rc_db=0
else
  rc_db=$?
fi

# 3) Load tests (Gatling)
if run_suite "gatling" "/app/tools/run_gatling.sh"; then
  rc_gatling=0
else
  rc_gatling=$?
fi

echo "▶ Suites finished: formy=${rc_formy}, db=${rc_db}, gatling=${rc_gatling}"

# Ensure gatling/latest exists if Gatling produced target reports under /reports/gatling/<timestamp>/
if [[ -d "${REPORTS_DIR}/gatling" ]]; then
  latest_dir="$(ls -1dt "${REPORTS_DIR}/gatling"/*/ 2>/dev/null | grep -v '/latest/' | head -n 1 || true)"
  if [[ -n "${latest_dir:-}" ]]; then
    rm -rf "${REPORTS_DIR}/gatling/latest" || true
    cp -a "${latest_dir%/}" "${REPORTS_DIR}/gatling/latest"
  fi
fi

# ✅ Contract: Allure results must exist and be non-empty
if ! find "${REPORTS_DIR}/allure-results" -type f -print -quit 2>/dev/null | grep -q .; then
  echo "❌ Allure results are missing/empty (${REPORTS_DIR}/allure-results) — failing build"
  exit 12
fi

# ✅ Generate Allure HTML report (static)
echo "▶ Generating Allure HTML report (${REPORTS_DIR}/allure-report)..."
rm -rf "${REPORTS_DIR}/allure-report"/*
allure generate \
  "${REPORTS_DIR}/allure-results/formy" \
  "${REPORTS_DIR}/allure-results/databaseUsage" \
  -o "${REPORTS_DIR}/allure-report" --clean

# ✅ Contract: Allure report must have index.html and required data files
if [[ ! -f "${REPORTS_DIR}/allure-report/index.html" ]]; then
  echo "❌ Allure report was not generated (missing allure-report/index.html) — failing build"
  exit 12
fi
if [[ ! -f "${REPORTS_DIR}/allure-report/data/summary.json" \
   || ! -f "${REPORTS_DIR}/allure-report/data/test-cases.json" \
   || ! -f "${REPORTS_DIR}/allure-report/data/suites.json" ]]; then
  echo "❌ Allure report incomplete (missing summary/test-cases/suites) — failing build"
  exit 13
fi
echo "✔ Allure report generated"

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
      <li>Report (HTML): <a href="allure-report/index.html">open</a></li>
      <li>Raw results: <code>allure-results/</code></li>
    </ul>
  </div>
</body>
</html>
HTML
echo "✔ ${REPORTS_DIR}/index.html generated"
ls -la "${REPORTS_DIR}" || true

# If no reports at all — fail
if [[ ! -f "${REPORTS_DIR}/formy/cucumber.json" \
   && ! -f "${REPORTS_DIR}/databaseUsage/cucumber.json" \
   && ! -f "${REPORTS_DIR}/gatling/latest/index.html" ]]; then
  echo "❌ No reports generated at all — failing build"
  exit 10
fi

# If any suite failed — fail, but reports remain
if [[ "${rc_formy}" -ne 0 || "${rc_db}" -ne 0 || "${rc_gatling}" -ne 0 ]]; then
  echo "❌ One or more suites failed — failing build"
  exit 11
fi

echo "✔ All QA test suites finished successfully"
