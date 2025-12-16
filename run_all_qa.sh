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

  docker rm -f "$container_name" >/dev/null 2>&1 || true
  rm -rf "$clean_dir" && mkdir -p "$clean_dir"

  set +e
  docker_compose up --no-deps --abort-on-container-exit --exit-code-from "$service" "$service"
  local exit_code=$?
  set -e

  copy_reports_from_container "$container_name"

  echo "$exit_code"
}

echo "▶ Building qa-tests image..."
docker_compose build

rc_formy="$(run_service_keep_container "formy-tests"        "qa-formy-tests"           "reports/formy")"
rc_db="$(run_service_keep_container    "database-tests"     "qa-database-tests"        "reports/databaseUsage")"
rc_gatling="$(run_service_keep_container "restfulbooker-load" "qa-gatling-restfulbooker" "reports/gatling")"

echo "▶ Exit codes: formy=$rc_formy db=$rc_db gatling=$rc_gatling"

echo "▶ Checking expected report files..."
formy_ok=0; db_ok=0; gatling_ok=0
[[ -f reports/formy/cucumber.json ]] && formy_ok=1
[[ -f reports/databaseUsage/cucumber.json ]] && db_ok=1
[[ -f reports/gatling/latest/index.html ]] && gatling_ok=1

echo "   formy cucumber.json: $([[ $formy_ok -eq 1 ]] && echo OK || echo MISSING)"
echo "   db cucumber.json:    $([[ $db_ok -eq 1 ]] && echo OK || echo MISSING)"
echo "   gatling index.html:  $([[ $gatling_ok -eq 1 ]] && echo OK || echo MISSING)"

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

# Финальная логика статуса билда:
# 1) если ничего не сгенерилось — fail
if [[ $formy_ok -eq 0 && $db_ok -eq 0 && $gatling_ok -eq 0 ]]; then
  echo "❌ No reports generated at all — failing build"
  exit 10
fi

# 2) если хоть один suite упал — fail (но остальные уже успели выполниться)
if [[ "$rc_formy" != "0" || "$rc_db" != "0" || "$rc_gatling" != "0" ]]; then
  echo "❌ One or more suites failed — failing build"
  exit 11
fi

echo "✔ All QA test suites finished successfully"