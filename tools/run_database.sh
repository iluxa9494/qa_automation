#!/usr/bin/env bash
# tools/run_database.sh
set -euo pipefail

BASE_DIR="/app/databaseUsage"

# Maven module (там лежит target/deps)
MODULE_DIR="${BASE_DIR}"
if [[ -d "${BASE_DIR}/databaseUsage" ]]; then
  MODULE_DIR="${BASE_DIR}/databaseUsage"
fi

# Root target (там лежит target/classes и target/test-classes)
ROOT_TARGET="${BASE_DIR}/target"
FEATURES_DIR="${BASE_DIR}/src/test/features"

REPORTS_BASE="${REPORTS_DIR:-/reports}"
REPORT_DIR="${REPORTS_BASE}/databaseUsage"

# ✅ Allure results dir (отдельная подпапка под suite)
ALLURE_BASE_DIR="${ALLURE_RESULTS_DIR:-${REPORTS_BASE}/allure-results}"
ALLURE_RESULTS_DIR="${ALLURE_BASE_DIR}/databaseUsage"

JAVA_OPTS="${JAVA_OPTS:-${MAVEN_OPTS:-}}"
read -r -a JAVA_OPTS_ARR <<< "${JAVA_OPTS}"
SUITE_TIMEOUT_SEC="${QA_SUITE_TIMEOUT_SECONDS:-1800}"

mkdir -p "${REPORT_DIR}" "${ALLURE_RESULTS_DIR}"

# --- очистка "мусора" от прошлых прогонов ---
rm -f "${REPORT_DIR}/cucumber.json" "${REPORT_DIR}/cucumber.html" 2>/dev/null || true
rm -f "${REPORT_DIR}/TEST-databaseUsage.xml" 2>/dev/null || true
rm -rf "${ROOT_TARGET}/cucumber"* 2>/dev/null || true
rm -rf "${ALLURE_RESULTS_DIR:?}/"* 2>/dev/null || true

# Рабочая директория — root проекта
cd "${BASE_DIR}"

DEPS_DIR="${MODULE_DIR}/target/deps"
CP="${DEPS_DIR}/*:${ROOT_TARGET}/classes:${ROOT_TARGET}/test-classes"

echo "▶ [databaseUsage] BASE_DIR=${BASE_DIR}"
echo "▶ [databaseUsage] MODULE_DIR=${MODULE_DIR}"
echo "▶ [databaseUsage] ROOT_TARGET=${ROOT_TARGET}"
echo "▶ [databaseUsage] DEPS_DIR=${DEPS_DIR}"
echo "▶ [databaseUsage] CP=${CP}"
echo "▶ [databaseUsage] ALLURE_RESULTS_DIR=${ALLURE_RESULTS_DIR}"

# ----------------------------------------------------------
# Tags control:
#  - CI quick run: DB_TAGS='@ci'
#  - run all:      DB_TAGS=''
# ----------------------------------------------------------
if [[ -z "${DB_TAGS+x}" ]]; then
  if [[ -n "${CI:-}" && "${CI}" != "0" && "${CI}" != "false" ]]; then
    DB_TAGS=""
  else
    DB_TAGS="@ci"
  fi
fi
if [[ -n "${DB_TAGS}" ]]; then
  echo "▶ [databaseUsage] cucumber.filter.tags=${DB_TAGS}"
else
  echo "▶ [databaseUsage] cucumber.filter.tags=<not set> (running all)"
fi

# Базовые проверки, чтобы не зависать на пустом classpath
if [[ ! -d "${DEPS_DIR}" ]]; then
  echo "❌ Missing deps dir: ${DEPS_DIR}"
  echo "   (You likely forgot to run mvn dependency:copy-dependencies during image build)"
  exit 21
fi

# Hard timeout to avoid multi-hour hangs when DB is unreachable.
DB_JAVA_PROPS=()
DB_JAVA_PROPS+=("-Dcucumber.execution.parallel.enabled=false")
DB_JAVA_PROPS+=("-Dallure.results.directory=${ALLURE_RESULTS_DIR}")
DB_JAVA_PROPS+=("-Dqa.junit.timeout.seconds=${QA_JUNIT_TIMEOUT_SECONDS:-1200}")
if [[ -n "${DB_TAGS}" ]]; then
  DB_JAVA_PROPS+=("-Dcucumber.filter.tags=${DB_TAGS}")
fi

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

echo "▶ [databaseUsage] Features dir: ${FEATURES_DIR}"
echo "▶ [databaseUsage] Total feature files: ${TOTAL_FEATURES}"
echo "▶ [databaseUsage] Total scenarios (raw): ${TOTAL_SCENARIOS}"
echo "▶ [databaseUsage] Maven/Surefire flags: ${MAVEN_FLAGS}"

if command -v timeout >/dev/null 2>&1; then
  timeout "${SUITE_TIMEOUT_SEC}"s java "${JAVA_OPTS_ARR[@]}" \
    "${DB_JAVA_PROPS[@]}" \
    -cp "${CP}" \
    org.junit.runner.JUnitCore CucumberRun
else
  java "${JAVA_OPTS_ARR[@]}" \
    "${DB_JAVA_PROPS[@]}" \
    -cp "${CP}" \
    org.junit.runner.JUnitCore CucumberRun
fi

if [[ -d "${ALLURE_RESULTS_DIR}" ]]; then
  executed_count="$(find "${ALLURE_RESULTS_DIR}" -type f -name '*-result.json' 2>/dev/null | wc -l | tr -d ' ')"
  echo "▶ [databaseUsage] Executed scenarios (Allure results): ${executed_count}"
fi
