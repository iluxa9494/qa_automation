#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="/app/databaseUsage"

# Maven module (там лежит target/deps)
MODULE_DIR="${BASE_DIR}"
if [[ -d "${BASE_DIR}/databaseUsage" ]]; then
  MODULE_DIR="${BASE_DIR}/databaseUsage"
fi

# Root target (там лежит target/classes и target/test-classes)
ROOT_TARGET="${BASE_DIR}/target"

REPORTS_BASE="${REPORTS_DIR:-/reports}"
REPORT_DIR="${REPORTS_BASE}/databaseUsage"

# ✅ Allure results dir (отдельная подпапка под suite)
ALLURE_BASE_DIR="${ALLURE_RESULTS_DIR:-${REPORTS_BASE}/allure-results}"
ALLURE_RESULTS_DIR="${ALLURE_BASE_DIR}/databaseUsage"

JAVA_OPTS="${JAVA_OPTS:-${MAVEN_OPTS:-}}"
read -r -a JAVA_OPTS_ARR <<< "${JAVA_OPTS}"

mkdir -p "${REPORT_DIR}" "${ALLURE_RESULTS_DIR}"

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

# Базовые проверки, чтобы не зависать на пустом classpath
if [[ ! -d "${DEPS_DIR}" ]]; then
  echo "❌ Missing deps dir: ${DEPS_DIR}"
  echo "   (You likely forgot to run mvn dependency:copy-dependencies during image build)"
  exit 21
fi

java "${JAVA_OPTS_ARR[@]}" \
  -Dallure.results.directory="${ALLURE_RESULTS_DIR}" \
  -cp "${CP}" \
  org.junit.runner.JUnitCore CucumberRun