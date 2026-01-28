#!/usr/bin/env bash
# tools/run_formy.sh
set -euo pipefail

BASE_DIR="/app/formyProject"

MODULE_DIR="${BASE_DIR}"
if [[ -d "${BASE_DIR}/formyProject" ]]; then
  MODULE_DIR="${BASE_DIR}/formyProject"
fi

ROOT_TARGET="${BASE_DIR}/target"
FEATURES_DIR="${BASE_DIR}/src/test/features"

REPORTS_BASE="${REPORTS_DIR:-/reports}"
REPORT_DIR="${REPORTS_BASE}/formy"

JAVA_OPTS="${JAVA_OPTS:-${MAVEN_OPTS:-}}"
read -r -a JAVA_OPTS_ARR <<< "${JAVA_OPTS}"
SUITE_TIMEOUT_SEC="${QA_SUITE_TIMEOUT_SECONDS:-1800}"

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
if [[ -z "${FORMY_TAGS+x}" ]]; then
  if [[ -n "${CI:-}" && "${CI}" != "0" && "${CI}" != "false" ]]; then
    FORMY_TAGS=""
  else
    FORMY_TAGS="@ci"
  fi
fi

# Optional “kill screenshots” flag for your own steps (если внедришь проверку в коде)
FORMY_SCREENSHOTS="${FORMY_SCREENSHOTS:-0}"

JAVA_PROPS=()
JAVA_PROPS+=("-Dcucumber.execution.parallel.enabled=false")
JAVA_PROPS+=("-Dallure.results.directory=${ALLURE_RESULTS_DIR}")
JAVA_PROPS+=("-Dqa.junit.timeout.seconds=${QA_JUNIT_TIMEOUT_SECONDS:-1200}")

TOTAL_FEATURES="0"
TOTAL_SCENARIOS="0"
if [[ -d "${FEATURES_DIR}" ]]; then
  TOTAL_FEATURES="$(find "${FEATURES_DIR}" -type f -name '*.feature' 2>/dev/null | wc -l | tr -d ' ')"
  TOTAL_SCENARIOS="$(find "${FEATURES_DIR}" -type f -name '*.feature' -print0 2>/dev/null | xargs -0 grep -E "^[[:space:]]*Scenario( Outline)?: " -h | wc -l | tr -d ' ')"
fi

MAVEN_FLAGS_RAW="${MAVEN_OPTS:-} ${MAVEN_CLI_OPTS:-} ${SUREFIRE_OPTS:-} ${JAVA_TOOL_OPTIONS:-}"
MAVEN_FLAGS="$(printf '%s' "${MAVEN_FLAGS_RAW}" | tr ' ' '\n' | grep -E '^-D(test=|skipTests|maven.test.skip|surefire\\.|failsafe\\.)' | paste -sd' ' - || true)"
if [[ -z "${MAVEN_FLAGS}" ]]; then
  MAVEN_FLAGS="<none> (runner=JUnitCore)"
fi

echo "▶ [formy] Features dir: ${FEATURES_DIR}"
echo "▶ [formy] Total feature files: ${TOTAL_FEATURES}"
echo "▶ [formy] Total scenarios (raw): ${TOTAL_SCENARIOS}"
echo "▶ [formy] Maven/Surefire flags: ${MAVEN_FLAGS}"

if [[ -n "${FORMY_TAGS}" ]]; then
  JAVA_PROPS+=("-Dcucumber.filter.tags=${FORMY_TAGS}")
  echo "▶ [formy] cucumber.filter.tags=${FORMY_TAGS}"
else
  echo "▶ [formy] cucumber.filter.tags=<not set> (running all)"
fi

JAVA_PROPS+=("-Dformy.screenshots=${FORMY_SCREENSHOTS}")
echo "▶ [formy] formy.screenshots=${FORMY_SCREENSHOTS}"

# Hard timeout to avoid multi-hour hangs on flaky UI retries.
if command -v timeout >/dev/null 2>&1; then
  timeout "${SUITE_TIMEOUT_SEC}"s java "${JAVA_OPTS_ARR[@]}" \
    "${JAVA_PROPS[@]}" \
    -cp "${CP}" \
    org.junit.runner.JUnitCore CucumberRun
else
  java "${JAVA_OPTS_ARR[@]}" \
    "${JAVA_PROPS[@]}" \
    -cp "${CP}" \
    org.junit.runner.JUnitCore CucumberRun
fi

if [[ -d "${ALLURE_RESULTS_DIR}" ]]; then
  executed_count="$(find "${ALLURE_RESULTS_DIR}" -type f -name '*-result.json' 2>/dev/null | wc -l | tr -d ' ')"
  echo "▶ [formy] Executed scenarios (Allure results): ${executed_count}"
fi
