#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="/app/formyProject"
MODULE_DIR="${BASE_DIR}"
if [[ -d "${BASE_DIR}/formyProject" ]]; then
  MODULE_DIR="${BASE_DIR}/formyProject"
fi

REPORT_DIR="${REPORTS_DIR:-/reports}/formy"
JAVA_OPTS="${JAVA_OPTS:-${MAVEN_OPTS:-}}"
read -r -a JAVA_OPTS_ARR <<< "${JAVA_OPTS}"

mkdir -p "${REPORT_DIR}"

export DISPLAY=:99
Xvfb :99 -screen 0 1280x720x24 >/dev/null 2>&1 &

cd "${MODULE_DIR}"

CP="${MODULE_DIR}/target/deps/*:${MODULE_DIR}/target/classes:${MODULE_DIR}/target/test-classes"
java "${JAVA_OPTS_ARR[@]}" -cp "${CP}" org.junit.runner.JUnitCore CucumberRun