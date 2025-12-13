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

echo "▶ Building qa-tests image (Docker)..."
docker_compose build || echo "⚠ Docker build failed — продолжаем"

echo "▶ Running UI tests (Formy)..."
docker_compose run --rm formy-tests || echo "⚠ UI tests failed — продолжаем"

echo "▶ Running DB tests (DatabaseUsage)..."
docker_compose run --rm database-tests || echo "⚠ DB tests failed — продолжаем"

echo "▶ Running load tests (Gatling)..."
docker_compose run --rm restfulbooker-load || echo "⚠ Load tests failed — продолжаем"

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