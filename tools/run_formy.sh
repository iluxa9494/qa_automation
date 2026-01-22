#!/usr/bin/env bash
set -euo pipefail

MODULE_DIR="/app/formyProject"
JAVA_OPTS="${JAVA_OPTS:-${MAVEN_OPTS:-}}"

read -r -a JAVA_OPTS_ARR <<< "${JAVA_OPTS}"

# UI tests need a display
export DISPLAY=:99
Xvfb :99 -screen 0 1280x720x24 >/dev/null 2>&1 &

cd "${MODULE_DIR}"

# Ensure Cucumber can write artifacts into target/
mkdir -p target/cucumber

CP="${MODULE_DIR}/target/deps/*:${MODULE_DIR}/target/classes:${MODULE_DIR}/target/test-classes"

# Run Cucumber via JUnit4 runner (no io.cucumber.core.cli.Main)
java "${JAVA_OPTS_ARR[@]}" -cp "${CP}" org.junit.runner.JUnitCore CucumberRun