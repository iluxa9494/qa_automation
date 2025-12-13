#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

# Jenkins читает ВСЁ из ./reports/**
mkdir -p \
  reports/formy \
  reports/databaseUsage \
  reports/gatling \
  reports/nested \
  reports/nested/attachments

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

echo "▶ Building qa-tests image (Docker)..."
docker_compose build || echo "⚠ Docker build failed — продолжаем"

# ---------------- UI (Formy) ----------------
echo "▶ Running UI tests (Formy)..."
docker_compose run --rm formy-tests || echo "⚠ UI tests failed — продолжаем"

if [[ -f "reports/formy/cucumber.json" ]]; then
  echo "✔ UI cucumber.json found"
else
  echo "⚠ UI cucumber.json NOT found"
fi

if [[ -f "reports/formy/cucumber-html-report/index.html" ]]; then
  echo "✔ UI HTML report found"
else
  echo "⚠ UI HTML report NOT found"
fi

# ---------------- DB (DatabaseUsage) ----------------
echo "▶ Running DB tests (DatabaseUsage)..."
docker_compose run --rm database-tests || echo "⚠ DB tests failed — продолжаем"

if [[ -f "reports/databaseUsage/cucumber.json" ]]; then
  echo "✔ DB cucumber.json found"
else
  echo "⚠ DB cucumber.json NOT found"
fi

if [[ -f "reports/databaseUsage/cucumber.html" ]]; then
  echo "✔ DB HTML report found"
else
  echo "⚠ DB HTML report NOT found"
fi

# ---------------- Load (Gatling) ----------------
echo "▶ Running load tests (Gatling)..."
docker_compose run --rm restfulbooker-load || echo "⚠ Load tests failed — продолжаем"

if [[ -f "reports/gatling/latest/index.html" ]]; then
  echo "✔ Gatling latest report ready"
else
  echo "⚠ Gatling latest report NOT found"
fi

# ---------------- Nested JSON ----------------
echo "▶ Generating Nested Data report..."

mkdir -p reports/nested

mvn -B -q \
  -f databaseUsage/pom.xml \
  -DskipTests \
  test-compile exec:java \
  -Dexec.mainClass=tools.NestedReportGenerator \
  || echo "⚠ Nested generator failed — продолжаем"

if [[ -f "reports/nested/data.json" ]]; then
  echo "✔ Nested data.json generated"
else
  echo "❌ Nested data.json NOT generated"
fi

echo "✔ All QA test suites finished"
echo "📊 Reports directory structure:"
find reports -maxdepth 3 -type f | sed 's|^|  - |'