#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

mkdir -p reports/formy reports/databaseUsage reports/gatling

echo "▶ Building qa-tests image (Docker)..."
docker compose build

echo "▶ Running UI tests (formyProject)..."
docker compose run --rm formy-tests

echo "▶ Running DB tests (databaseUsage)..."
docker compose run --rm database-tests

echo "▶ Running load tests (restfulBookerLoad)..."
docker compose run --rm restfulbooker-load

echo "✔ All QA test suites finished. Reports are in ./reports/"