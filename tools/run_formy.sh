# /Users/ilia/IdeaProjects/pet_projects/qa_automation/tools/run_formy.sh
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
if [[ -d "${BASE_DIR}/target" ]]; then
  ROOT_TARGET="${BASE_DIR}/target"
fi

REPORT_DIR="${REPORTS_DIR:-/reports}/formy"
JAVA_OPTS="${JAVA_OPTS:-${MAVEN_OPTS:-}}"
read -r -a JAVA_OPTS_ARR <<< "${JAVA_OPTS}"

mkdir -p "${REPORT_DIR}"

export DISPLAY=:99
Xvfb :99 -screen 0 1280x720x24 >/dev/null 2>&1 &

# Рабочая директория — root проекта, чтобы относительные пути/ресурсы работали ожидаемо
cd "${BASE_DIR}"

DEPS_DIR="${MODULE_DIR}/target/deps"

CP="${DEPS_DIR}/*:${ROOT_TARGET}/classes:${ROOT_TARGET}/test-classes"

echo "▶ [formy] BASE_DIR=${BASE_DIR}"
echo "▶ [formy] MODULE_DIR=${MODULE_DIR}"
echo "▶ [formy] ROOT_TARGET=${ROOT_TARGET}"
echo "▶ [formy] DEPS_DIR=${DEPS_DIR}"
echo "▶ [formy] CP=${CP}"

java "${JAVA_OPTS_ARR[@]}" -cp "${CP}" org.junit.runner.JUnitCore CucumberRun