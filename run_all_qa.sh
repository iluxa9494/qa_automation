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
docker_compose build || echo "⚠ Docker image build finished with non-zero code, продолжаем для демо"

echo "▶ Running UI tests (formyProject)..."
docker_compose run --rm formy-tests || echo "⚠ UI tests (formyProject) failed — помечаем как красные, но пайплайн продолжается"

echo "▶ Running DB tests (databaseUsage)..."
docker_compose run --rm database-tests || echo "⚠ DB tests (databaseUsage) failed — помечаем как красные, но пайплайн продолжается"

echo "▶ Running load tests (restfulBookerLoad)..."
docker_compose run --rm restfulbooker-load || echo "⚠ Load tests (restfulBookerLoad) failed — помечаем как красные, но пытаемся собрать отчёт"

echo "▶ Preparing Gatling report for Jenkins (creating stable 'latest' link)..."
GATLING_DIR="reports/gatling"

if [[ -f "$GATLING_DIR/lastRun.txt" ]]; then
  LAST_RUN_DIR_NAME="$(cat "$GATLING_DIR/lastRun.txt")"
  LAST_RUN_DIR_PATH="$GATLING_DIR/$LAST_RUN_DIR_NAME"

  if [[ -d "$LAST_RUN_DIR_PATH" ]]; then
    # Удаляем старый симлинк/папку latest, если был
    rm -rf "$GATLING_DIR/latest"
    # Симлинк на последнюю директорию отчёта (например, getbookingfixeddurationloadcheck-2025...)
    ln -s "$LAST_RUN_DIR_NAME" "$GATLING_DIR/latest"
    echo "   ✔ Latest Gatling report: $GATLING_DIR/latest/index.html"
  else
    echo "⚠ lastRun.txt указывает на '$LAST_RUN_DIR_NAME', но такой директории нет в $GATLING_DIR"
  fi
else
  echo "⚠ lastRun.txt не найден в $GATLING_DIR, Gatling-репорт не подготовлен"
fi

echo "✔ All QA test suites finished. Reports are in ./reports/"