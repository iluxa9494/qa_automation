#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

# ✅ защита от параллельных запусков (вдруг кто-то нажмёт кнопку 2 раза)
LOCK_FILE="/tmp/qa_automation.lock"
exec 200>"$LOCK_FILE"
flock -n 200 || { echo "❌ QA already running (lock: $LOCK_FILE)"; exit 2; }

mkdir -p reports/formy reports/databaseUsage reports/gatling reports/nested

docker_compose() {
  if docker compose version >/dev/null 2>&1; then
    docker compose "$@"
  elif command -v docker-compose >/dev/null 2>&1; then
    docker-compose "$@"
  else
    echo "❌ Docker Compose не установлен." >&2
    exit 1
  fi
}

cleanup() {
  docker_compose down --remove-orphans >/dev/null 2>&1 || true
}
trap cleanup EXIT

run_service() {
  local service="$1"
  echo "▶ Running: $service"
  set +e
  docker_compose up --no-deps --abort-on-container-exit --exit-code-from "$service" "$service"
  local rc=$?
  set -e
  echo "✔ $service finished with rc=$rc"
  return "$rc"
}

echo "▶ Pulling latest QA image..."
docker_compose pull || true

# DB всегда подняты на время прогона
echo "▶ Starting DB dependencies..."
docker_compose up -d mongo mysql

echo "▶ Running suites sequentially..."
rc_formy=0
rc_db=0
rc_gatling=0

if ! run_service "formy-tests"; then rc_formy=$?; fi
if ! run_service "database-tests"; then rc_db=$?; fi
if ! run_service "restfulbooker-load"; then rc_gatling=$?; fi

echo "▶ Exit codes: formy=$rc_formy db=$rc_db gatling=$rc_gatling"

echo "▶ Generating QA Dashboard (reports/index.html)..."
cat > reports/index.html <<'HTML'
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

echo "✔ reports/index.html generated"
ls -la reports || true

# если отчётов вообще нет — фейлим
if [[ ! -f reports/formy/cucumber.json && ! -f reports/databaseUsage/cucumber.json && ! -f reports/gatling/latest/index.html ]]; then
  echo "❌ No reports generated at all — failing build"
  exit 10
fi

if [[ "$rc_formy" != "0" || "$rc_db" != "0" || "$rc_gatling" != "0" ]]; then
  echo "❌ One or more suites failed — failing build"
  exit 11
fi

echo "✔ All QA test suites finished successfully"