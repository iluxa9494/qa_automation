#!/usr/bin/env bash
set -euo pipefail

REPORTS_DIR="${REPORTS_DIR:-/reports}"
PORT="${QA_DASHBOARD_PORT:-8005}"

mkdir -p "${REPORTS_DIR}"

exec python3 -m http.server "${PORT}" --directory "${REPORTS_DIR}"
