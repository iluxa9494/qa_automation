#!/usr/bin/env bash
set -euo pipefail

MODULE_DIR="/app/databaseUsage"
REPORT_DIR="/reports/databaseUsage"
JAVA_OPTS="${JAVA_OPTS:-${MAVEN_OPTS:-}}"

read -r -a JAVA_OPTS_ARR <<< "${JAVA_OPTS}"

mkdir -p "${REPORT_DIR}/surefire"

cd "${MODULE_DIR}"

CP="${MODULE_DIR}/target/deps/*:${MODULE_DIR}/target/classes:${MODULE_DIR}/target/test-classes"

java "${JAVA_OPTS_ARR[@]}" -cp "${CP}" io.cucumber.core.cli.Main \
  --plugin pretty \
  --plugin "json:${REPORT_DIR}/cucumber.json" \
  --plugin "html:${REPORT_DIR}/cucumber.html" \
  --glue Steps \
  src/test/features
