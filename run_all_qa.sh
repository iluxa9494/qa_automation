#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

LOCK_FILE="/tmp/qa_automation.lock"
exec 200>"$LOCK_FILE"
flock -n 200 || { echo "❌ QA already running (lock: $LOCK_FILE)"; exit 2; }

mkdir -p reports/formy reports/databaseUsage reports/gatling reports/nested

detect_compose_cmd() {
  if docker compose version >/dev/null 2>&1; then
    echo "docker compose"
  elif command -v docker-compose >/dev/null 2>&1; then
    echo "docker-compose"
  else
    echo ""
  fi
}

pick_compose_file() {
  if [[ -n "${COMPOSE_FILE:-}" ]]; then
    echo "$COMPOSE_FILE"
    return 0
  fi

  local candidates=(
    "docker-compose.ci.yml"
    "docker-compose.ci.yaml"
    "docker-compose.yml"
    "docker-compose.yaml"
    "compose.yml"
    "compose.yaml"
  )

  local f
  for f in "${candidates[@]}"; do
    if [[ -f "$f" ]]; then
      echo "$f"
      return 0
    fi
  done

  echo ""
}

COMPOSE_CMD="$(detect_compose_cmd)"
if [[ -z "$COMPOSE_CMD" ]]; then
  echo "❌ Docker Compose не установлен." >&2
  exit 1
fi

COMPOSE_FILE_RESOLVED="$(pick_compose_file)"
if [[ -z "$COMPOSE_FILE_RESOLVED" ]]; then
  echo "❌ Compose file not found. Expected docker-compose.ci.yml (or set COMPOSE_FILE)." >&2
  exit 1
fi

echo "▶ Using compose: $COMPOSE_CMD -f $COMPOSE_FILE_RESOLVED"

docker_compose() {
  # shellcheck disable=SC2086
  $COMPOSE_CMD -f "$COMPOSE_FILE_RESOLVED" "$@"
}

cleanup() {
  docker_compose down --remove-orphans >/dev/null 2>&1 || true
}
trap cleanup EXIT

list_services() {
  docker_compose config --services 2>/dev/null || true
}

service_exists() {
  local s="$1"
  list_services | grep -qx "$s"
}

echo "▶ Compose services detected:"
SERVICES="$(list_services)"
if [[ -z "$SERVICES" ]]; then
  echo "❌ Could not read services from compose. Check $COMPOSE_FILE_RESOLVED is valid." >&2
  exit 1
fi
echo "$SERVICES" | sed 's/^/ - /'

# sanity checks for your current compose
service_exists "qa_automation" || { echo "❌ service qa_automation not found in compose"; exit 1; }
service_exists "mysql"        || { echo "❌ service mysql not found in compose"; exit 1; }
service_exists "mongodb"      || { echo "❌ service mongodb not found in compose"; exit 1; }

echo "▶ Pulling latest images..."
docker_compose pull || true

echo "▶ Starting DB dependencies..."
docker_compose up -d mysql mongodb

echo "▶ Running qa_automation container (will execute all suites inside)..."
set +e
docker_compose up --no-deps --abort-on-container-exit --exit-code-from qa_automation qa_automation
rc=$?
set -e
echo "✔ qa_automation finished with rc=$rc"

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

# Если контейнер вернул ошибку — фейлим workflow (но отчёты уже синкнутся)
if [[ "$rc" != "0" ]]; then
  echo "❌ qa_automation failed (rc=$rc) — failing build"
  exit 11
fi

echo "✔ All QA test suites finished successfully"