#!/usr/bin/env bash
# tools/run_gatling.sh
set -euo pipefail

BASE_DIR="/app/restfulBookerLoad"

# Maven module (там лежит target/deps)
MODULE_DIR="${BASE_DIR}"
if [[ -d "${BASE_DIR}/restfulBookerLoad" ]]; then
  MODULE_DIR="${BASE_DIR}/restfulBookerLoad"
fi

# Root target (там лежит target/classes и target/test-classes)
ROOT_TARGET="${BASE_DIR}/target"
if [[ -d "${BASE_DIR}/target" ]]; then
  ROOT_TARGET="${BASE_DIR}/target"
fi

REPORT_DIR="${REPORTS_DIR:-/reports}/gatling"
JAVA_OPTS="${JAVA_OPTS:-${MAVEN_OPTS:-}}"
read -r -a JAVA_OPTS_ARR <<< "${JAVA_OPTS}"

mkdir -p "${REPORT_DIR}"

# Рабочая директория — root проекта
cd "${BASE_DIR}"

DEPS_DIR="${MODULE_DIR}/target/deps"
CP="${DEPS_DIR}/*:${ROOT_TARGET}/classes:${ROOT_TARGET}/test-classes"

echo "▶ [gatling] BASE_DIR=${BASE_DIR}"
echo "▶ [gatling] MODULE_DIR=${MODULE_DIR}"
echo "▶ [gatling] ROOT_TARGET=${ROOT_TARGET}"
echo "▶ [gatling] DEPS_DIR=${DEPS_DIR}"
echo "▶ [gatling] CP=${CP}"
echo "▶ [gatling] REPORT_DIR=${REPORT_DIR}"

# ✅ CI-safe параметры (можно переопределить env-ом из compose/CI)
G_USERS="${GATLING_CI_USERS_PER_SEC:-5}"
G_DUR="${GATLING_CI_DURATION_SEC:-30}"
G_PAUSE="${GATLING_CI_PAUSE_MS:-300}"

java "${JAVA_OPTS_ARR[@]}" -cp "${CP}" io.gatling.app.Gatling \
  -Dgatling.ci.usersPerSec="${G_USERS}" \
  -Dgatling.ci.durationSec="${G_DUR}" \
  -Dgatling.ci.pauseMs="${G_PAUSE}" \
  -s simulations.GETBookingFixedDurationLoadCheck \
  -rf "${REPORT_DIR}"