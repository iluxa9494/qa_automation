#!/usr/bin/env bash
set -euo pipefail

MODULE_DIR="/app/restfulBookerLoad"
REPORT_DIR="/reports/gatling"
JAVA_OPTS="${JAVA_OPTS:-${MAVEN_OPTS:-}}"

read -r -a JAVA_OPTS_ARR <<< "${JAVA_OPTS}"

mkdir -p "${REPORT_DIR}"

cd "${MODULE_DIR}"

CP="${MODULE_DIR}/target/deps/*:${MODULE_DIR}/target/classes:${MODULE_DIR}/target/test-classes"

java "${JAVA_OPTS_ARR[@]}" -cp "${CP}" io.gatling.app.Gatling \
  -s simulations.GETBookingFixedDurationLoadCheck \
  -rf "${REPORT_DIR}"

LAST_DIR="$(ls -1dt "${REPORT_DIR}"/*/ 2>/dev/null | grep -v "/latest/" | head -n 1 || true)"
if [[ -n "${LAST_DIR}" ]]; then
  rm -rf "${REPORT_DIR}/latest"
  mkdir -p "${REPORT_DIR}/latest"
  cp -a "${LAST_DIR%/}"/. "${REPORT_DIR}/latest/"
else
  echo "⚠ Gatling report directory not found in ${REPORT_DIR}"
  exit 2
fi
