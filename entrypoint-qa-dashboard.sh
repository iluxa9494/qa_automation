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

# ✅ Если есть allure-results — генерим/обновляем allure-report
if find "${ALLURE_RESULTS_DIR}" -type f -print -quit >/dev/null 2>&1; then
  if command -v allure >/dev/null 2>&1; then
    echo "▶ [dashboard] Generating Allure report..."
    rm -rf "${ALLURE_REPORT_DIR:?}/"*
    allure generate "${ALLURE_RESULTS_DIR}" -o "${ALLURE_REPORT_DIR}" --clean

    if [[ -f "${ALLURE_REPORT_DIR}/index.html" ]]; then
      echo "✔ [dashboard] Allure report ready: ${ALLURE_REPORT_DIR}/index.html"
    else
      echo "❌ [dashboard] Allure report generation failed (missing index.html)"
    fi
  else
    echo "❌ [dashboard] Allure CLI not found in image"
  fi
else
  echo "⚠️ [dashboard] No allure-results found; skipping report generation"
fi

# Раздаём статику (дашборд + formy/db/gatling/allure)
exec python3 -m http.server "${PORT}" --directory "${REPORTS_DIR}"