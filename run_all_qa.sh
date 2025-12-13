#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

# Jenkins читает всё из ./reports/**
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

# ---- helpers: run container w/o bind-mounts and copy /reports out ----
copy_reports_from_container() {
  local container_name="$1"
  local src_path="${2:-/reports}"
  local dst_dir="${3:-reports}"

  if docker ps -a --format '{{.Names}}' | grep -qx "$container_name"; then
    echo "▶ Copying reports from $container_name:$src_path -> ./$dst_dir ..."
    mkdir -p "$dst_dir"
    # Важно: docker cp умеет копировать директорию целиком
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

  echo "▶ Running: $service (container: $container_name) ..."
  # На всякий: если остался от прошлого запуска
  docker rm -f "$container_name" >/dev/null 2>&1 || true

  set +e
  docker_compose up --no-deps --abort-on-container-exit --exit-code-from "$service" "$service"
  local exit_code=$?
  set -e

  # В любом случае пытаемся вытащить /reports
  copy_reports_from_container "$container_name" "/reports" "reports"

  if [[ $exit_code -ne 0 ]]; then
    echo "⚠ $service failed (exit=$exit_code) — продолжаем"
  fi
  return 0
}

echo "▶ Building qa-tests image (Docker)..."
docker_compose build || echo "⚠ Docker build failed — продолжаем"

# ---------------- UI (Formy) ----------------
run_service_keep_container "formy-tests" "qa-formy-tests"

# ---------------- DB (DatabaseUsage) ----------------
run_service_keep_container "database-tests" "qa-database-tests"

# ---------------- Load (Gatling) ----------------
run_service_keep_container "restfulbooker-load" "qa-gatling-restfulbooker"

echo "▶ Checking expected report files..."
[[ -f reports/formy/cucumber.json ]] && echo "   ✔ reports/formy/cucumber.json" || echo "⚠ reports/formy/cucumber.json NOT found"
[[ -f reports/databaseUsage/cucumber.json ]] && echo "   ✔ reports/databaseUsage/cucumber.json" || echo "⚠ reports/databaseUsage/cucumber.json NOT found"
[[ -f reports/gatling/latest/index.html ]] && echo "   ✔ reports/gatling/latest/index.html" || echo "⚠ reports/gatling/latest/index.html NOT found"

echo "▶ Generating Nested Data report (reports/nested/data.json)..."
mkdir -p reports/nested

# Генератор читает:
#   reports/databaseUsage/cucumber.json
#   reports/formy/cucumber.json
# и пишет:
#   reports/nested/data.json
mvn -B -q -f databaseUsage/pom.xml -DskipTests test-compile \
  exec:java -Dexec.mainClass=tools.NestedReportGenerator -Dexec.classpathScope=test \
  || echo "⚠ Nested generator failed — продолжаем"

[[ -f reports/nested/data.json ]] && echo "   ✔ reports/nested/data.json generated" || echo "❌ reports/nested/data.json NOT generated"

echo "✔ All QA test suites finished"
echo "📊 Reports directory structure:"
ls -la reports || true