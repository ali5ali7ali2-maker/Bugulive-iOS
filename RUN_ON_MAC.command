#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")"

echo "Starting first pass build for BuguLive..."

if [ ! -f "scripts/run_all_ios_first_pass.sh" ]; then
  echo "Missing scripts/run_all_ios_first_pass.sh"
  exit 1
fi

bash scripts/run_all_ios_first_pass.sh

echo "Done. If build failed, check build/ios_build.log"
