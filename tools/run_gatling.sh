# /Users/ilia/IdeaProjects/pet_projects/qa_automation/tools/run_gatling.sh
#!/usr/bin/env bash
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

java "${JAVA_OPTS_ARR[@]}" -cp "${CP}" io.gatling.app.Gatling \
  -s simulations.GETBookingFixedDurationLoadCheck \
  -rf "${REPORT_DIR}"