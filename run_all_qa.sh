#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

mkdir -p reports/formy reports/databaseUsage reports/gatling reports/nested

docker_compose() {
  if docker compose version >/dev/null 2>&1; then
    docker compose "$@"
  elif command -v docker-compose >/dev/null 2>&1; then
    docker-compose "$@"
  else
    echo "❌ Docker Compose не установлен." >&2
    exit 2
  fi
}

preflight() {
  echo "▶ Preflight: docker доступ"
  if ! command -v docker >/dev/null 2>&1; then
    echo "❌ docker CLI не найден в окружении Jenkins" >&2
    exit 2
  fi
  if ! docker ps >/dev/null 2>&1; then
    echo "❌ Нет доступа к Docker daemon (docker.sock). Jenkins должен иметь доступ к /var/run/docker.sock." >&2
    exit 2
  fi
  docker_compose version >/dev/null 2>&1 || true
}

copy_reports_from_container() {
  local container_name="$1"
  if docker ps -a --format '{{.Names}}' | grep -qx "$container_name"; then
    echo "▶ Copying reports from $container_name:/reports -> ./reports ..."
    docker cp "${container_name}:/reports/." "reports/" 2>/dev/null || true
    docker rm -f "$container_name" >/dev/null 2>&1 || true
  else
    echo "⚠ Container $container_name not found — nothing to copy"
  fi
}

run_service() {
  local service="$1"
  local container_name="$2"
  local clean_dir="$3"

  echo "▶ Running suite: $service"
  docker rm -f "$container_name" >/dev/null 2>&1 || true
  rm -rf "$clean_dir" && mkdir -p "$clean_dir"

  set +e
  docker_compose up --no-deps --abort-on-container-exit --exit-code-from "$service" "$service"
  local exit_code=$?
  set -e

  copy_reports_from_container "$container_name"
  return "$exit_code"
}

generate_dashboard() {
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
}

preflight

echo "▶ Building qa-tests image..."
docker_compose build

failures=0
ran_any=0

if run_service "formy-tests" "qa-formy-tests" "reports/formy"; then
  ran_any=1
else
  ran_any=1
  failures=$((failures+1))
  echo "⚠ formy-tests failed — продолжаем"
fi

if run_service "database-tests" "qa-database-tests" "reports/databaseUsage"; then
  ran_any=1
else
  ran_any=1
  failures=$((failures+1))
  echo "⚠ database-tests failed — продолжаем"
fi

if run_service "restfulbooker-load" "qa-gatling-restfulbooker" "reports/gatling"; then
  ran_any=1
else
  ran_any=1
  failures=$((failures+1))
  echo "⚠ restfulbooker-load failed — продолжаем"
fi

generate_dashboard

echo "▶ Checking expected report files..."
[[ -f reports/formy/cucumber.json ]] && echo "   ✔ formy cucumber.json" || { echo "❌ formy cucumber.json NOT found"; failures=$((failures+1)); }
[[ -f reports/databaseUsage/cucumber.json ]] && echo "   ✔ db cucumber.json" || { echo "❌ db cucumber.json NOT found"; failures=$((failures+1)); }
[[ -f reports/gatling/latest/index.html ]] && echo "   ✔ gatling latest/index.html" || { echo "❌ gatling latest/index.html NOT found"; failures=$((failures+1)); }

echo "📊 Reports directory:"
ls -la reports || true

if [[ "$ran_any" -eq 0 ]]; then
  echo "❌ Ничего не запустилось — падаем"
  exit 2
fi

if [[ "$failures" -gt 0 ]]; then
  echo "❌ Есть проблемы (failures=$failures) — делаем билд красным"
  exit 1
fi

echo "✔ All QA test suites finished successfully"