#!/usr/bin/env bash
set -euo pipefail

MODULE_DIR="/app/restfulBookerLoad"
JAVA_OPTS="${JAVA_OPTS:-${MAVEN_OPTS:-}}"

read -r -a JAVA_OPTS_ARR <<< "${JAVA_OPTS}"

cd "${MODULE_DIR}"

# IMPORTANT: output into module target/ so collect_reports.sh can copy it later
REPORT_DIR="${MODULE_DIR}/target/gatling"
mkdir -p "${REPORT_DIR}"

CP="${MODULE_DIR}/target/deps/*:${MODULE_DIR}/target/classes:${MODULE_DIR}/target/test-classes"

# Run Gatling directly (requires gatling-app on classpath)
java "${JAVA_OPTS_ARR[@]}" -cp "${CP}" io.gatling.app.Gatling \
  -s simulations.GETBookingFixedDurationLoadCheck \
  -rf "${REPORT_DIR}"