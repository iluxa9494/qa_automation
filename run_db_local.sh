#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
COMPOSE_FILE="$ROOT_DIR/docker-compose.db.yml"

RESET_DB="${RESET_DB:-0}"

start_stack() {
  if [[ "$RESET_DB" == "1" ]]; then
    echo "⚠ RESET_DB=1 -> пересоздаём volumes (нужно для init.sql и при смене версии MySQL)"
    docker compose -f "$COMPOSE_FILE" down -v
  fi

  echo "▶ Starting MySQL & MongoDB locally (Docker)..."
  docker compose -f "$COMPOSE_FILE" up -d
}

wait_healthy() {
  local name="$1"

  echo "▶ Waiting for $name to be ready..."
  for _ in {1..60}; do
    if docker ps --format '{{.Names}}' | grep -q "^${name}$"; then
      status="$(docker inspect -f '{{.State.Health.Status}}' "$name" 2>/dev/null || echo starting)"
      if [[ "$status" == "healthy" ]]; then
        echo "✔ $name is healthy"
        return 0
      fi
    else
      echo "❌ $name container is not running. Logs:"
      docker logs "$name" --tail 200 || true
      return 1
    fi
    sleep 2
  done

  echo "❌ $name did not become healthy in time. Logs:"
  docker logs "$name" --tail 200 || true
  return 1
}

start_stack

# Mongo обычно стабилен
wait_healthy qa-mongo

# MySQL: если упал — делаем down -v и стартуем заново один раз
if ! wait_healthy qa-mysql; then
  echo "⚠ MySQL failed. Trying once with volume reset..."
  RESET_DB=1
  start_stack
  wait_healthy qa-mysql
fi

echo "▶ Containers:"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | (head -n 1; grep -E 'qa-mongo|qa-mysql' || true)

export MONGO_URI="mongodb://localhost:27017"
export MYSQL_URL="jdbc:mysql://localhost:3306/test"
export MYSQL_USER="test"
export MYSQL_PASSWORD="test"

echo "▶ Running databaseUsage tests via Maven..."
cd "$ROOT_DIR/databaseUsage"
mvn -B clean test

# ✅ Синхронизация отчётов в ./reports
echo "▶ Sync DB reports to $ROOT_DIR/reports/databaseUsage ..."
mkdir -p "$ROOT_DIR/reports/databaseUsage"

cp -f "$ROOT_DIR/databaseUsage/target/cucumber.html" \
      "$ROOT_DIR/reports/databaseUsage/cucumber.html"

cp -f "$ROOT_DIR/databaseUsage/target/cucumber/cucumber.json" \
      "$ROOT_DIR/reports/databaseUsage/cucumber.json"

echo "✔ Database tests finished"
echo "📄 Reports:"
echo " - HTML (module): databaseUsage/target/cucumber.html"
echo " - JSON (module): databaseUsage/target/cucumber/cucumber.json"
echo " - HTML (reports): reports/databaseUsage/cucumber.html"
echo " - JSON (reports): reports/databaseUsage/cucumber.json"
