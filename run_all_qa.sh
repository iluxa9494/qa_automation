#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

# Папки под отчёты (Jenkins читает всё из ./reports/**)
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

# ---------------- UI (Formy) ----------------
echo "▶ Running UI tests (formyProject)..."
docker_compose run --rm formy-tests || echo "⚠ UI tests failed — пайплайн продолжается"

echo "▶ Sync UI reports (formyProject) to ./reports/formy ..."
mkdir -p reports/formy

# JSON для nested
if [[ -f "formyProject/target/cucumber/cucumber.json" ]]; then
  cp -f "formyProject/target/cucumber/cucumber.json" "reports/formy/cucumber.json"
  echo "   ✔ JSON: reports/formy/cucumber.json"
else
  echo "⚠ UI cucumber.json not found: formyProject/target/cucumber/cucumber.json"
fi

# HTML для publishHTML (папка с index.html)
if [[ -d "formyProject/target/cucumber-html-report" ]]; then
  rm -rf "reports/formy/cucumber-html-report"
  cp -a "formyProject/target/cucumber-html-report" "reports/formy/cucumber-html-report"
  echo "   ✔ HTML: reports/formy/cucumber-html-report/index.html"
else
  echo "⚠ UI cucumber-html-report not found: formyProject/target/cucumber-html-report"
fi

# ---------------- DB (databaseUsage) ----------------
echo "▶ Running DB tests (databaseUsage)..."
docker_compose run --rm database-tests || echo "⚠ DB tests failed — пайплайн продолжается"

echo "▶ Sync DB reports (databaseUsage) to ./reports/databaseUsage ..."
mkdir -p reports/databaseUsage

if [[ -f "databaseUsage/target/cucumber/cucumber.json" ]]; then
  cp -f "databaseUsage/target/cucumber/cucumber.json" "reports/databaseUsage/cucumber.json"
  echo "   ✔ JSON: reports/databaseUsage/cucumber.json"
else
  echo "⚠ DB cucumber.json not found: databaseUsage/target/cucumber/cucumber.json"
fi

if [[ -f "databaseUsage/target/cucumber.html" ]]; then
  cp -f "databaseUsage/target/cucumber.html" "reports/databaseUsage/cucumber.html"
  echo "   ✔ HTML: reports/databaseUsage/cucumber.html"
else
  echo "⚠ DB cucumber.html not found: databaseUsage/target/cucumber.html"
fi

# ---------------- Load (Gatling) ----------------
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
  # fallback: берём последнюю по времени директорию
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

# ---------------- Nested JSON (aggregated) ----------------
echo "▶ Generating Nested Data report (reports/nested/data.json)..."
mkdir -p reports/nested

# ✅ Запускаем Java-генератор через Maven, чтобы подтянулись зависимости (Jackson)
# Генератор читает:
#   reports/databaseUsage/cucumber.json
#   reports/formy/cucumber.json
# и пишет:
#   reports/nested/data.json
mvn -B -q -f databaseUsage/pom.xml -DskipTests test-compile \
  exec:java -Dexec.mainClass=tools.NestedReportGenerator \
  || echo "⚠ Failed to generate nested data.json (maven/java error) — пайплайн продолжается"

echo "✔ All QA test suites finished. Reports are in ./reports/"