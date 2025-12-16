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
    exit 1
  fi
}

# ✅ Если docker недоступен в Jenkins — это инфраструктурная ошибка, падаем сразу
echo "▶ Preflight: docker доступ"
docker version >/dev/null
docker ps >/dev/null

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

  echo "▶ Running service: $service"

  docker rm -f "$container_name" >/dev/null 2>&1 || true
  rm -rf "$clean_dir" && mkdir -p "$clean_dir"

  set +e
  docker_compose up --no-deps --abort-on-container-exit --exit-code-from "$service" "$service"
  local exit_code=$?
  set -e

  copy_reports_from_container "$container_name"

  if [[ $exit_code -ne 0 ]]; then
    echo "⚠ $service failed (exit=$exit_code) — продолжаем (это может быть падение тестов)"
  fi

  return "$exit_code"
}

echo "▶ Building qa-tests image..."
# ✅ build не должен быть "soft": если образ не собрался — дальше смысла нет
docker_compose build

formy_ec=0
db_ec=0
gatling_ec=0

set +e
run_service_keep_container "formy-tests"        "qa-formy-tests"            "reports/formy"
formy_ec=$?
run_service_keep_container "database-tests"     "qa-database-tests"         "reports/databaseUsage"
db_ec=$?
run_service_keep_container "restfulbooker-load" "qa-gatling-restfulbooker"  "reports/gatling"
gatling_ec=$?
set -e

echo "▶ Checking expected report files..."
formy_ok=0
db_ok=0
gatling_ok=0

if [[ -f reports/formy/cucumber.json ]]; then
  echo "   ✔ formy cucumber.json"
  formy_ok=1
else
  echo "⚠ formy cucumber.json NOT found"
fi

if [[ -f reports/databaseUsage/cucumber.json ]]; then
  echo "   ✔ db cucumber.json"
  db_ok=1
else
  echo "⚠ db cucumber.json NOT found"
fi

if [[ -f reports/gatling/latest/index.html ]]; then
  echo "   ✔ gatling latest/index.html"
  gatling_ok=1
else
  echo "⚠ gatling latest/index.html NOT found"
fi

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
    .badge { display:inline-block; padding:2px 8px; border-radius:999px; font-size:12px; border:1px solid #ddd; }
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

  <p style="opacity:.7;margin-top:24px">
    Если Formy/DB упали — проверь консоль билда и наличие cucumber.json.
  </p>
</body>
</html>
HTML

echo "✔ reports/index.html generated"
echo "📦 Exit codes: formy=$formy_ec db=$db_ec gatling=$gatling_ec"

# ✅ Если вообще ничего не получилось (все отчёты отсутствуют) — это уже не "тесты упали", а "ничего не запустилось"
sum_ok=$((formy_ok + db_ok + gatling_ok))
if [[ "$sum_ok" -eq 0 ]]; then
  echo "❌ No reports produced at all — failing build (инфраструктура/контейнеры/пути)"
  exit 10
fi

# ✅ Иначе оставляем билд зелёным, даже если один suite упал — отчёты будут в Jenkins
echo "✔ All QA suites finished (some may have failed)."
ls -la reports || true
exit 0