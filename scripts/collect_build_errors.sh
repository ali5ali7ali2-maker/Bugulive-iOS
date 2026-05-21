#!/usr/bin/env bash
set -euo pipefail

# Extract concise error summary from xcodebuild log
# Usage: bash scripts/collect_build_errors.sh

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
LOG_FILE="${ROOT_DIR}/build/ios_build.log"

if [[ ! -f "${LOG_FILE}" ]]; then
  echo "No build log found at ${LOG_FILE}"
  exit 1
fi

echo "===== First compile errors ====="
grep -n " error:" "${LOG_FILE}" | head -n 40 || true

echo "===== First linker errors ====="
grep -n "ld: " "${LOG_FILE}" | head -n 40 || true

echo "===== First duplicate symbol errors ====="
grep -n "duplicate symbol" "${LOG_FILE}" | head -n 40 || true
