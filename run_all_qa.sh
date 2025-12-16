#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

mkdir -p reports/formy reports/databaseUsage reports/gatling

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

run_suite() {
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
  return "$exit_code"
}

echo "▶ Building qa-tests image..."
docker_compose build

fail_count=0

echo "▶ Run: formy-tests"
run_suite "formy-tests" "qa-formy-tests" "reports/formy" || fail_count=$((fail_count+1))

echo "▶ Run: database-tests"
run_suite "database-tests" "qa-database-tests" "reports/databaseUsage" || fail_count=$((fail_count+1))

echo "▶ Run: restfulbooker-load"
run_suite "restfulbooker-load" "qa-gatling-restfulbooker" "reports/gatling" || fail_count=$((fail_count+1))

echo "▶ Checking expected report files..."
found_any=0
[[ -f reports/formy/cucumber.json ]] && { echo "   ✔ formy cucumber.json"; found_any=1; } || echo "⚠ formy cucumber.json NOT found"
[[ -f reports/databaseUsage/cucumber.json ]] && { echo "   ✔ db cucumber.json"; found_any=1; } || echo "⚠ db cucumber.json NOT found"
[[ -f reports/gatling/latest/index.html ]] && { echo "   ✔ gatling latest/index.html"; found_any=1; } || echo "⚠ gatling latest/index.html NOT found"

# Если вообще ничего не появилось — это “ничего не запускалось/всё сломано”
if [[ "$found_any" -eq 0 ]]; then
  echo "❌ No reports were generated at all -> failing build"
  exit 1
fi

# Если упали ВСЕ 3 — красная джоба
if [[ "$fail_count" -ge 3 ]]; then
  echo "❌ All suites failed -> failing build"
  exit 1
fi

echo "✔ Done (some suites may have failed, see logs)"
ls -la reports || true