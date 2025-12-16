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

echo "▶ Preflight: docker доступ"
if ! docker ps >/dev/null 2>&1; then
  echo "❌ Нет доступа к Docker daemon (docker.sock). Jenkins должен иметь доступ к /var/run/docker.sock." >&2
  exit 2
fi

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

run_service_keep_container() {
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

  if [[ $exit_code -ne 0 ]]; then
    echo "⚠ $service failed (exit=$exit_code) — продолжаем"
  else
    echo "✔ $service OK"
  fi

  return $exit_code
}

echo "▶ Building qa-tests image..."
docker_compose build

fail_count=0
ok_count=0

run_service_keep_container "formy-tests"        "qa-formy-tests"           "reports/formy"         && ok_count=$((ok_count+1)) || fail_count=$((fail_count+1))
run_service_keep_container "database-tests"     "qa-database-tests"        "reports/databaseUsage" && ok_count=$((ok_count+1)) || fail_count=$((fail_count+1))
run_service_keep_container "restfulbooker-load" "qa-gatling-restfulbooker" "reports/gatling"       && ok_count=$((ok_count+1)) || fail_count=$((fail_count+1))

echo "▶ Checking expected report files..."
[[ -f reports/formy/cucumber.json ]] && echo "   ✔ formy cucumber.json" || echo "⚠ formy cucumber.json NOT found"
[[ -f reports/databaseUsage/cucumber.json ]] && echo "   ✔ db cucumber.json" || echo "⚠ db cucumber.json NOT found"
[[ -f reports/gatling/latest/index.html ]] && echo "   ✔ gatling latest/index.html" || echo "⚠ gatling latest/index.html NOT found"

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

# ✅ Правило фейла: если все suites упали — билд красный
if [[ $ok_count -eq 0 ]]; then
  echo "❌ Все тестовые наборы упали/не запустились. fail_count=$fail_count"
  exit 1
fi

echo "✔ Done. ok_count=$ok_count fail_count=$fail_count"
exit 0