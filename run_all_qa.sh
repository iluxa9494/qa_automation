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

LAST_RUN_DIR_NAME=""
if [[ -f "$GATLING_DIR/lastRun.txt" ]]; then
  LAST_RUN_DIR_NAME="$(tr -d '\r\n' < "$GATLING_DIR/lastRun.txt")"
fi

if [[ -n "$LAST_RUN_DIR_NAME" && -d "$GATLING_DIR/$LAST_RUN_DIR_NAME" ]]; then
  LAST_RUN_DIR_PATH="$GATLING_DIR/$LAST_RUN_DIR_NAME"
else
  LAST_RUN_DIR_PATH="$(ls -1dt "$GATLING_DIR"/*/ 2>/dev/null | head -n 1 || true)"
  LAST_RUN_DIR_PATH="${LAST_RUN_DIR_PATH%/}"
fi

if [[ -n "${LAST_RUN_DIR_PATH:-}" && -d "$LAST_RUN_DIR_PATH" ]]; then
  rm -rf "$LATEST_DIR"
  mkdir -p "$LATEST_DIR"
  cp -a "$LAST_RUN_DIR_PATH"/. "$LATEST_DIR"/
  echo "   ✔ Latest Gatling report prepared: $LATEST_DIR/index.html"
else
  echo "⚠ Gatling report directory not found in $GATLING_DIR — latest не подготовлен"
fi

echo "▶ Generating Nested Data report (reports/nested/data.json)..."
mkdir -p reports/nested

# ✅ Запускаем Java-генератор через Maven, чтобы подтянулись зависимости (Jackson)
# Генератор читает:
#   databaseUsage/target/cucumber/cucumber.json
#   formyProject/target/cucumber/cucumber.json
# и пишет:
#   reports/nested/data.json
mvn -B -q -f databaseUsage/pom.xml -DskipTests test-compile \
  exec:java -Dexec.mainClass=tools.NestedReportGenerator \
  || echo "⚠ Failed to generate nested data.json (maven/java error) — пайплайн продолжается"

echo "✔ All QA test suites finished. Reports are in ./reports/"