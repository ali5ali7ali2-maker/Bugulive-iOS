#!/usr/bin/env bash
set -euo pipefail

# One-command first pass for BuguLive iOS on macOS
# Usage: bash scripts/run_all_ios_first_pass.sh

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

bash scripts/bootstrap_ios_mac.sh

if bash scripts/build_ios_debug.sh; then
  echo "SUCCESS: Initial Debug build passed."
else
  echo "Build failed. Collecting concise errors..."
  bash scripts/collect_build_errors.sh || true
  exit 1
fi
