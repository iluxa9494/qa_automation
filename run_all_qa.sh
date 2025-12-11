#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

mkdir -p reports/formy reports/databaseUsage reports/gatling

docker_compose() {
  # Сначала пробуем Docker Compose v2: `docker compose`
  if docker compose version >/dev/null 2>&1; then
    docker compose "$@"
  # Если нет — пробуем классический бинарник `docker-compose`
  elif command -v docker-compose >/dev/null 2>&1; then
    docker-compose "$@"
  else
    echo "❌ Docker Compose не установлен (ни 'docker compose', ни 'docker-compose' не найдены)." >&2
    exit 1
  fi
}

echo "▶ Building qa-tests image (Docker)..."
docker_compose build

echo "▶ Running UI tests (formyProject)..."
docker_compose run --rm formy-tests

echo "▶ Running DB tests (databaseUsage)..."
docker_compose run --rm database-tests

echo "▶ Running load tests (restfulBookerLoad)..."
docker_compose run --rm restfulbooker-load

echo "✔ All QA test suites finished. Reports are in ./reports/"