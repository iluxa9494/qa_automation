# /Users/ilia/IdeaProjects/pet_projects/qa_automation/tools/run_database.sh
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
if [[ -d "${BASE_DIR}/target" ]]; then
  ROOT_TARGET="${BASE_DIR}/target"
fi

REPORT_DIR="${REPORTS_DIR:-/reports}/databaseUsage"
JAVA_OPTS="${JAVA_OPTS:-${MAVEN_OPTS:-}}"
read -r -a JAVA_OPTS_ARR <<< "${JAVA_OPTS}"

mkdir -p "${REPORT_DIR}"

# Рабочая директория — root проекта, чтобы относительные пути/ресурсы работали ожидаемо
cd "${BASE_DIR}"

DEPS_DIR="${MODULE_DIR}/target/deps"

CP="${DEPS_DIR}/*:${ROOT_TARGET}/classes:${ROOT_TARGET}/test-classes"

echo "▶ [databaseUsage] BASE_DIR=${BASE_DIR}"
echo "▶ [databaseUsage] MODULE_DIR=${MODULE_DIR}"
echo "▶ [databaseUsage] ROOT_TARGET=${ROOT_TARGET}"
echo "▶ [databaseUsage] DEPS_DIR=${DEPS_DIR}"
echo "▶ [databaseUsage] CP=${CP}"

java "${JAVA_OPTS_ARR[@]}" -cp "${CP}" org.junit.runner.JUnitCore CucumberRun