#!/usr/bin/env bash
# tools/run_gatling.sh
set -euo pipefail

BASE_DIR="/app/restfulBookerLoad"

# Maven module (там лежит target/deps)
MODULE_DIR="${BASE_DIR}"
if [[ -d "${BASE_DIR}/restfulBookerLoad" ]]; then
  MODULE_DIR="${BASE_DIR}/restfulBookerLoad"
fi

# Root target (там лежит target/classes и target/test-classes)
ROOT_TARGET="${BASE_DIR}/target"
if [[ -d "${BASE_DIR}/target" ]]; then
  ROOT_TARGET="${BASE_DIR}/target"
fi

REPORT_DIR="${REPORTS_DIR:-/reports}/gatling"
JAVA_OPTS="${JAVA_OPTS:-${MAVEN_OPTS:-}}"
GATLING_JAVA_OPTS="${GATLING_JAVA_OPTS:-}"

mkdir -p "${REPORT_DIR}"

# Рабочая директория — root проекта
cd "${BASE_DIR}"

DEPS_DIR="${MODULE_DIR}/target/deps"
CP="${DEPS_DIR}/*:${ROOT_TARGET}/classes:${ROOT_TARGET}/test-classes"

echo "▶ [gatling] BASE_DIR=${BASE_DIR}"
echo "▶ [gatling] MODULE_DIR=${MODULE_DIR}"
echo "▶ [gatling] ROOT_TARGET=${ROOT_TARGET}"
echo "▶ [gatling] DEPS_DIR=${DEPS_DIR}"
echo "▶ [gatling] CP=${CP}"
echo "▶ [gatling] REPORT_DIR=${REPORT_DIR}"

# ---- permissions diagnostics + normalization (before latest update) ----
echo "▶ [gatling] Perms diagnostics (pre-latest):"
id || true
ls -la "${REPORT_DIR}" || true
if [[ -e "${REPORT_DIR}/latest" ]]; then
  stat -c '%u:%g %a %n' "${REPORT_DIR}/latest" || true
fi
find "${REPORT_DIR}" -maxdepth 2 -printf '%u:%g %m %p\n' 2>/dev/null || true

# Normalize ownership to parent reports dir (only if running as root)
if [[ "$(id -u)" == "0" ]]; then
  reports_root="${REPORTS_DIR:-/reports}"
  owner_uid_gid="$(stat -c '%u:%g' "${reports_root}" 2>/dev/null || true)"
  if [[ -n "${owner_uid_gid}" ]]; then
    chown -R "${owner_uid_gid}" "${REPORT_DIR}" || true
  fi
fi
chmod -R u+rwX "${REPORT_DIR}" || true

# ✅ CI-safe параметры (можно переопределить env-ом из compose/CI)
G_USERS="${GATLING_CI_USERS_PER_SEC:-5}"
G_DUR="${GATLING_CI_DURATION_SEC:-30}"
G_PAUSE="${GATLING_CI_PAUSE_MS:-300}"
G_TIMEOUT="${GATLING_CI_TIMEOUT_SEC:-$((G_DUR + 60))}"

# JVM system properties must be before the main class (or in JAVA_OPTS/GATLING_JAVA_OPTS)
JAVA_OPTS="${JAVA_OPTS} ${GATLING_JAVA_OPTS} -Dgatling.ci.usersPerSec=${G_USERS} -Dgatling.ci.durationSec=${G_DUR} -Dgatling.ci.pauseMs=${G_PAUSE}"
read -r -a JAVA_OPTS_ARR <<< "${JAVA_OPTS}"

if command -v timeout >/dev/null 2>&1; then
  timeout "${G_TIMEOUT}"s java "${JAVA_OPTS_ARR[@]}" -cp "${CP}" io.gatling.app.Gatling \
    -s simulations.RestfulBookerFullLoad \
    -rf "${REPORT_DIR}"
else
  java "${JAVA_OPTS_ARR[@]}" -cp "${CP}" io.gatling.app.Gatling \
    -s simulations.RestfulBookerFullLoad \
    -rf "${REPORT_DIR}"
fi

# ---- stabilize "latest" report ----
echo "▶ [gatling] Resolving latest report folder..."
latest_report_dir="$(
  find "${REPORT_DIR}" -mindepth 2 -maxdepth 2 -type f -name index.html -printf '%T@ %h\n' 2>/dev/null \
    | sort -nr \
    | head -n 1 \
    | awk '{ $1=""; sub(/^ /,""); print }'
)"

if [[ -n "${latest_report_dir}" ]]; then
  # Re-check after run (reports might be created as a different UID/GID)
  if [[ "$(id -u)" == "0" ]]; then
    reports_root="${REPORTS_DIR:-/reports}"
    owner_uid_gid="$(stat -c '%u:%g' "${reports_root}" 2>/dev/null || true)"
    if [[ -n "${owner_uid_gid}" ]]; then
      chown -R "${owner_uid_gid}" "${REPORT_DIR}" || true
    fi
  fi
  chmod -R u+rwX "${REPORT_DIR}" || true
  rm -rf "${REPORT_DIR}/latest" || true
  cp -a "${latest_report_dir}" "${REPORT_DIR}/latest"
  echo "✔ [gatling] latest -> ${latest_report_dir}"
else
  echo "❌ [gatling] No Gatling index.html found under ${REPORT_DIR}"
  echo "▶ [gatling] Report dir listing:"
  ls -la "${REPORT_DIR}" || true
  echo "▶ [gatling] index.html search:"
  find "${REPORT_DIR}" -maxdepth 3 -type f -name index.html -print || true
fi
