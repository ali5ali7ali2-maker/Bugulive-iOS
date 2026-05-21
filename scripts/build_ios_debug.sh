#!/usr/bin/env bash
set -euo pipefail

# BuguLive iOS build script for macOS Simulator
# Usage: bash scripts/build_ios_debug.sh

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

WORKSPACE="BuguLive.xcworkspace"
SCHEME="BuguLive"
DESTINATION="platform=iOS Simulator,name=iPhone 15"
DERIVED_DATA="${ROOT_DIR}/build/DerivedData"
LOG_FILE="${ROOT_DIR}/build/ios_build.log"

mkdir -p "${ROOT_DIR}/build"

echo "Building workspace=${WORKSPACE} scheme=${SCHEME} destination=${DESTINATION}"
set -o pipefail
xcodebuild \
  -workspace "${WORKSPACE}" \
  -scheme "${SCHEME}" \
  -configuration Debug \
  -destination "${DESTINATION}" \
  -derivedDataPath "${DERIVED_DATA}" \
  clean build | tee "${LOG_FILE}"

echo "Build completed. Log: ${LOG_FILE}"
