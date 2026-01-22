#!/usr/bin/env bash
set -euo pipefail

MODULE_DIR="/app/databaseUsage"
JAVA_OPTS="${JAVA_OPTS:-${MAVEN_OPTS:-}}"

read -r -a JAVA_OPTS_ARR <<< "${JAVA_OPTS}"

cd "${MODULE_DIR}"

mkdir -p target/cucumber

CP="${MODULE_DIR}/target/deps/*:${MODULE_DIR}/target/classes:${MODULE_DIR}/target/test-classes"

# Run Cucumber via JUnit4 runner (no io.cucumber.core.cli.Main)
java "${JAVA_OPTS_ARR[@]}" -cp "${CP}" org.junit.runner.JUnitCore CucumberRun