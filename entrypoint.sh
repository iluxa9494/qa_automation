#!/usr/bin/env bash
set -euo pipefail

REPORTS_DIR="${REPORTS_DIR:-/reports}"

mkdir -p "${REPORTS_DIR}/formy" "${REPORTS_DIR}/databaseUsage" "${REPORTS_DIR}/gatling" "${REPORTS_DIR}/nested"

echo "▶ QA container runner started"
echo "▶ Reports dir: ${REPORTS_DIR}"
echo "▶ JAVA_OPTS: ${JAVA_OPTS:-<empty>}"

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

echo "▶ Generating QA Dashboard (reports/index.html)..."
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
      <li>HTML: <a href="formy/cucumber-html-report/index.html">open</a></li>
      <li>JSON: <code>reports/formy/cucumber.json</code></li>
    </ul>
  </div>

  <div class="card">
    <h2>DB tests</h2>
    <ul>
      <li>HTML: <a href="databaseUsage/cucumber.html">open</a></li>
      <li>JSON: <code>reports/databaseUsage/cucumber.json</code></li>
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
ls -la "${REPORTS_DIR}" || true

# если отчётов вообще нет — фейлим
if [[ ! -f "${REPORTS_DIR}/formy/cucumber.json" \
   && ! -f "${REPORTS_DIR}/databaseUsage/cucumber.json" \
   && ! -f "${REPORTS_DIR}/gatling/latest/index.html" ]]; then
  echo "❌ No reports generated at all — failing build"
  exit 10
fi

# если хотя бы одна suite упала — фейлим, но отчёты уже есть
if [[ "${rc_formy}" -ne 0 || "${rc_db}" -ne 0 || "${rc_gatling}" -ne 0 ]]; then
  echo "❌ One or more suites failed — failing build"
  exit 11
fi

echo "✔ All QA test suites finished successfully"