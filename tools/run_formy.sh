#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="/app/formyProject"

# Maven module (там лежит target/deps)
MODULE_DIR="${BASE_DIR}"
if [[ -d "${BASE_DIR}/formyProject" ]]; then
  MODULE_DIR="${BASE_DIR}/formyProject"
fi

# Root target (там лежит target/classes и target/test-classes)
ROOT_TARGET="${BASE_DIR}/target"

REPORTS_BASE="${REPORTS_DIR:-/reports}"
REPORT_DIR="${REPORTS_BASE}/formy"

JAVA_OPTS="${JAVA_OPTS:-${MAVEN_OPTS:-}}"
read -r -a JAVA_OPTS_ARR <<< "${JAVA_OPTS}"

# ✅ Allure results dir (отдельная подпапка под suite)
ALLURE_BASE_DIR="${ALLURE_RESULTS_DIR:-${REPORTS_BASE}/allure-results}"
ALLURE_RESULTS_DIR="${ALLURE_BASE_DIR}/formy"

mkdir -p "${REPORT_DIR}" "${ALLURE_RESULTS_DIR}"

# ---- Xvfb ----
export DISPLAY=:99
Xvfb :99 -screen 0 1280x720x24 >/dev/null 2>&1 &
XVFB_PID=$!

cleanup() {
  kill "${XVFB_PID}" >/dev/null 2>&1 || true
}
trap cleanup EXIT

# Рабочая директория — root проекта, чтобы относительные пути/ресурсы работали ожидаемо
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
  echo "   (You likely forgot to run mvn dependency:copy-dependencies during image build)"
  exit 21
fi

java "${JAVA_OPTS_ARR[@]}" \
  -Dallure.results.directory="${ALLURE_RESULTS_DIR}" \
  -cp "${CP}" \
  org.junit.runner.JUnitCore CucumberRun