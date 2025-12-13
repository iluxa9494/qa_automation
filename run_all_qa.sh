#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

# Папки под отчёты
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

echo "▶ Building qa-tests image (Docker)..."
docker_compose build || echo "⚠ Docker image build finished with non-zero code, продолжаем"

echo "▶ Running UI tests (formyProject)..."
docker_compose run --rm formy-tests || echo "⚠ UI tests failed — пайплайн продолжается"

echo "▶ Running DB tests (databaseUsage)..."
docker_compose run --rm database-tests || echo "⚠ DB tests failed — пайплайн продолжается"

echo "▶ Running load tests (restfulBookerLoad)..."
docker_compose run --rm restfulbooker-load || echo "⚠ Load tests failed — пайплайн продолжается"

echo "▶ Preparing Gatling report for Jenkins (stable 'latest' folder)..."
GATLING_DIR="reports/gatling"
LATEST_DIR="$GATLING_DIR/latest"

# ВНИМАНИЕ: у тебя lastRun.txt должен оказываться в reports/gatling/lastRun.txt
# (обычно его создаёт Gatling Maven plugin). Если его нет — fallback на "самую свежую директорию".
LAST_RUN_DIR_NAME=""
if [[ -f "$GATLING_DIR/lastRun.txt" ]]; then
  LAST_RUN_DIR_NAME="$(tr -d '\r\n' < "$GATLING_DIR/lastRun.txt")"
fi

if [[ -n "$LAST_RUN_DIR_NAME" && -d "$GATLING_DIR/$LAST_RUN_DIR_NAME" ]]; then
  LAST_RUN_DIR_PATH="$GATLING_DIR/$LAST_RUN_DIR_NAME"
else
  # fallback: берём последнюю по времени директорию
  LAST_RUN_DIR_PATH="$(ls -1dt "$GATLING_DIR"/*/ 2>/dev/null | head -n 1 || true)"
  LAST_RUN_DIR_PATH="${LAST_RUN_DIR_PATH%/}"
fi

if [[ -n "${LAST_RUN_DIR_PATH:-}" && -d "$LAST_RUN_DIR_PATH" ]]; then
  rm -rf "$LATEST_DIR"
  mkdir -p "$LATEST_DIR"
  # Копируем содержимое последнего прогона в стабильную папку latest
  cp -a "$LAST_RUN_DIR_PATH"/. "$LATEST_DIR"/
  echo "   ✔ Latest Gatling report prepared: $LATEST_DIR/index.html"
else
  echo "⚠ Gatling report directory not found in $GATLING_DIR — latest не подготовлен"
fi

echo "▶ Generating Nested Data report (reports/nested/data.json)..."

# Пути к входным данным (совпадают с docker-compose'ом)
export CUCUMBER_UI_JSON="reports/formy/cucumber.json"
export CUCUMBER_DB_JSON="reports/databaseUsage/cucumber.json"

# Gatling: предпочитаем чистый JSON (global_stats.json)
export GATLING_GLOBAL_STATS_JSON="reports/gatling/latest/js/global_stats.json"

# Куда писать итоговый json для Jenkins nested-data-reporting plugin
export NESTED_OUT_JSON="reports/nested/data.json"

# Генератор на Java (без внешних зависимостей)
mkdir -p .tmp-nested reports/nested

javac -encoding UTF-8 -d .tmp-nested tools/NestedReportGenerator.java
java -cp .tmp-nested NestedReportGenerator || echo "⚠ Failed to generate nested data.json (java error) — пайплайн продолжается"

echo "✔ All QA test suites finished. Reports are in ./reports/"