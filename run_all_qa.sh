#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

mkdir -p reports/formy reports/databaseUsage reports/gatling reports/nested reports/nested/attachments

docker_compose() {
  if docker compose version >/dev/null 2>&1; then
    docker compose "$@"
  elif command -v docker-compose >/dev/null 2>&1; then
    docker-compose "$@"
  else
    echo "❌ Docker Compose не установлен (ни 'docker compose', ни 'docker-compose' не найдены)." >&2
    exit 1
  fi
}

# ✅ всегда стартуем с чистых DB volumes, чтобы init.sql применялся каждый прогон
echo "▶ Reset docker stack (down -v) to apply DB init.sql..."
docker_compose down -v --remove-orphans >/dev/null 2>&1 || true

copy_reports_from_container() {
  local container_name="$1"
  local src_path="${2:-/reports}"
  local dst_dir="${3:-reports}"

  if docker ps -a --format '{{.Names}}' | grep -qx "$container_name"; then
    echo "▶ Copying reports from $container_name:$src_path -> ./$dst_dir ..."
    mkdir -p "$dst_dir"
    docker cp "${container_name}:${src_path}/." "${dst_dir}/" 2>/dev/null || true
    echo "▶ Removing container $container_name ..."
    docker rm -f "$container_name" >/dev/null 2>&1 || true
  else
    echo "⚠ Container $container_name not found — nothing to copy"
  fi
}

run_service_keep_container() {
  local service="$1"
  local container_name="$2"
  local clean_dir="$3"

  echo "▶ Running: $service (container: $container_name) ..."

  docker rm -f "$container_name" >/dev/null 2>&1 || true

  rm -rf "$clean_dir"
  mkdir -p "$clean_dir"

  set +e
  docker_compose up --no-deps --abort-on-container-exit --exit-code-from "$service" "$service"
  local exit_code=$?
  set -e

  copy_reports_from_container "$container_name" "/reports" "reports"

  if [[ $exit_code -ne 0 ]]; then
    echo "⚠ $service failed (exit=$exit_code) — продолжаем"
  fi
  return 0
}

echo "▶ Building qa-tests image (Docker)..."
docker_compose build || echo "⚠ Docker build failed — продолжаем"

run_service_keep_container "formy-tests"         "qa-formy-tests"           "reports/formy"
run_service_keep_container "database-tests"      "qa-database-tests"        "reports/databaseUsage"
run_service_keep_container "restfulbooker-load"  "qa-gatling-restfulbooker" "reports/gatling"

echo "▶ Checking expected report files..."
[[ -f reports/formy/cucumber.json ]] && echo "   ✔ reports/formy/cucumber.json" || echo "⚠ reports/formy/cucumber.json NOT found"
[[ -f reports/databaseUsage/cucumber.json ]] && echo "   ✔ reports/databaseUsage/cucumber.json" || echo "⚠ reports/databaseUsage/cucumber.json NOT found"
[[ -f reports/gatling/latest/index.html ]] && echo "   ✔ reports/gatling/latest/index.html" || echo "⚠ reports/gatling/latest/index.html NOT found"

echo "▶ Generating Nested HTML report (reports/nested/index.html)..."
mkdir -p reports/nested

set +e
mvn -B -q -f databaseUsage/pom.xml -DskipTests test-compile \
  exec:java -Dexec.mainClass=tools.NestedReportGenerator -Dexec.classpathScope=test
gen_ec=$?
set -e

# ✅ чтобы кнопка в Jenkins всегда открывалась
if [[ $gen_ec -ne 0 || ! -f reports/nested/index.html ]]; then
  echo "⚠ Nested generator failed or did not produce index.html — generating stub"
  cat > reports/nested/index.html <<'HTML'
<!doctype html>
<html lang="en"><head><meta charset="utf-8"><title>QA Summary (Nested)</title></head>
<body style="font-family: sans-serif">
<h2>QA Summary (Nested)</h2>
<p>Stub: nested generator failed or input reports missing.</p>
<p>Check presence of:</p>
<ul>
  <li>reports/formy/cucumber.json</li>
  <li>reports/databaseUsage/cucumber.json</li>
</ul>
</body></html>
HTML
fi

echo "✔ All QA test suites finished"
echo "📊 Reports directory structure:"
ls -la reports || true