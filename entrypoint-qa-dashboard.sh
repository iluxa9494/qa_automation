#!/usr/bin/env bash
set -euo pipefail

REPORTS_DIR="${REPORTS_DIR:-/reports}"
PORT="${QA_DASHBOARD_PORT:-8005}"

ALLURE_RESULTS_DIR="${ALLURE_RESULTS_DIR:-${REPORTS_DIR}/allure-results}"
ALLURE_REPORT_DIR="${ALLURE_REPORT_DIR:-${REPORTS_DIR}/allure-report}"

mkdir -p "${REPORTS_DIR}" "${ALLURE_RESULTS_DIR}" "${ALLURE_REPORT_DIR}"

echo "▶ [dashboard] REPORTS_DIR=${REPORTS_DIR}"
echo "▶ [dashboard] ALLURE_RESULTS_DIR=${ALLURE_RESULTS_DIR}"
echo "▶ [dashboard] ALLURE_REPORT_DIR=${ALLURE_REPORT_DIR}"
echo "▶ [dashboard] PORT=${PORT}"

# Allure report must be generated in CI and uploaded to VPS. No generation here.
if [[ -f "${ALLURE_REPORT_DIR}/index.html" ]]; then
  echo "✔ [dashboard] Using pre-generated Allure report: ${ALLURE_REPORT_DIR}/index.html"
else
  echo "❌ [dashboard] Missing pre-generated Allure report at ${ALLURE_REPORT_DIR}"
fi

# Раздаём статику (дашборд + formy/db/gatling/allure)
exec python3 -m http.server "${PORT}" --directory "${REPORTS_DIR}"
