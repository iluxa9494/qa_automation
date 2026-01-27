#!/usr/bin/env bash
# tools/run_formy.sh
set -euo pipefail

BASE_DIR="/app/formyProject"

MODULE_DIR="${BASE_DIR}"
if [[ -d "${BASE_DIR}/formyProject" ]]; then
  MODULE_DIR="${BASE_DIR}/formyProject"
fi

ROOT_TARGET="${BASE_DIR}/target"

REPORTS_BASE="${REPORTS_DIR:-/reports}"
REPORT_DIR="${REPORTS_BASE}/formy"

JAVA_OPTS="${JAVA_OPTS:-${MAVEN_OPTS:-}}"
read -r -a JAVA_OPTS_ARR <<< "${JAVA_OPTS}"

ALLURE_BASE_DIR="${ALLURE_RESULTS_DIR:-${REPORTS_BASE}/allure-results}"
ALLURE_RESULTS_DIR="${ALLURE_BASE_DIR}/formy"

mkdir -p "${REPORT_DIR}" "${ALLURE_RESULTS_DIR}"

rm -f "${REPORT_DIR}/cucumber.json" "${REPORT_DIR}/cucumber.html" 2>/dev/null || true
rm -f "${REPORT_DIR}/TEST-formy.xml" 2>/dev/null || true
rm -rf "${ROOT_TARGET}/cucumber"* 2>/dev/null || true
rm -rf "${ALLURE_RESULTS_DIR:?}/"* 2>/dev/null || true

# ---- Xvfb ----
export DISPLAY=:99
Xvfb :99 -screen 0 1280x720x24 >/dev/null 2>&1 &
XVFB_PID=$!
cleanup() { kill "${XVFB_PID}" >/dev/null 2>&1 || true; }
trap cleanup EXIT

cd "${BASE_DIR}"

DEPS_DIR="${MODULE_DIR}/target/deps"
CP="${DEPS_DIR}/*:${ROOT_TARGET}/classes:${ROOT_TARGET}/test-classes"

echo "▶ [formy] BASE_DIR=${BASE_DIR}"
echo "▶ [formy] MODULE_DIR=${MODULE_DIR}"
echo "▶ [formy] ROOT_TARGET=${ROOT_TARGET}"
echo "▶ [formy] DEPS_DIR=${DEPS_DIR}"
echo "▶ [formy] CP=${CP}"
echo "▶ [formy] ALLURE_RESULTS_DIR=${ALLURE_RESULTS_DIR}"

if [[ ! -d "${DEPS_DIR}" ]]; then
  echo "❌ Missing deps dir: ${DEPS_DIR}"
  exit 21
fi

# ----------------------------------------------------------
# Tags control:
#  - CI (no browser):   FORMY_TAGS='not @ui'
#  - UI w/o screenshots:FORMY_TAGS='@ui and not @visual'
#  - full UI:           FORMY_TAGS='@ui'
# ----------------------------------------------------------
FORMY_TAGS="${FORMY_TAGS:-}"

# Optional “kill screenshots” flag for your own steps (если внедришь проверку в коде)
FORMY_SCREENSHOTS="${FORMY_SCREENSHOTS:-0}"

JAVA_PROPS=()
JAVA_PROPS+=("-Dcucumber.execution.parallel.enabled=false")
JAVA_PROPS+=("-Dallure.results.directory=${ALLURE_RESULTS_DIR}")
JAVA_PROPS+=("-Dqa.junit.timeout.seconds=${QA_JUNIT_TIMEOUT_SECONDS:-1200}")

if [[ -n "${FORMY_TAGS}" ]]; then
  JAVA_PROPS+=("-Dcucumber.filter.tags=${FORMY_TAGS}")
  echo "▶ [formy] cucumber.filter.tags=${FORMY_TAGS}"
else
  echo "▶ [formy] cucumber.filter.tags=<not set> (running all)"
fi

JAVA_PROPS+=("-Dformy.screenshots=${FORMY_SCREENSHOTS}")
echo "▶ [formy] formy.screenshots=${FORMY_SCREENSHOTS}"

java "${JAVA_OPTS_ARR[@]}" \
  "${JAVA_PROPS[@]}" \
  -cp "${CP}" \
  org.junit.runner.JUnitCore CucumberRun
