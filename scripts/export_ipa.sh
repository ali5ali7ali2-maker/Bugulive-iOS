#!/usr/bin/env bash
set -euo pipefail

# Export signed IPA for BuguLive
# Usage:
#   bash scripts/export_ipa.sh "<TEAM_ID>" "<BUNDLE_ID>" [SCHEME]
# Example:
#   bash scripts/export_ipa.sh ABCD123456 com.yourcompany.bugulive BuguLive

TEAM_ID="${1:-}"
BUNDLE_ID="${2:-}"
SCHEME="${3:-BuguLive}"

if [[ -z "${TEAM_ID}" || -z "${BUNDLE_ID}" ]]; then
  echo "ERROR: Missing TEAM_ID or BUNDLE_ID"
  echo "Usage: bash scripts/export_ipa.sh \"<TEAM_ID>\" \"<BUNDLE_ID>\" [SCHEME]"
  exit 1
fi

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

WORKSPACE="BuguLive.xcworkspace"
ARCHIVE_PATH="${ROOT_DIR}/build/${SCHEME}.xcarchive"
EXPORT_PATH="${ROOT_DIR}/build/ipa"
EXPORT_PLIST="${ROOT_DIR}/scripts/ExportOptions-adhoc.plist"

mkdir -p "${ROOT_DIR}/build"
rm -rf "${ARCHIVE_PATH}" "${EXPORT_PATH}"

if ! command -v xcodebuild >/dev/null 2>&1; then
  echo "ERROR: xcodebuild not found. Run on macOS with Xcode installed."
  exit 1
fi

if [[ ! -f "${WORKSPACE}" ]]; then
  echo "ERROR: ${WORKSPACE} not found. Run pod install first."
  exit 1
fi

cat > "${EXPORT_PLIST}" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>method</key>
  <string>ad-hoc</string>
  <key>signingStyle</key>
  <string>automatic</string>
  <key>teamID</key>
  <string>${TEAM_ID}</string>
  <key>compileBitcode</key>
  <false/>
  <key>stripSwiftSymbols</key>
  <true/>
  <key>destination</key>
  <string>export</string>
</dict>
</plist>
PLIST

echo "[1/3] Archiving ${SCHEME}..."
xcodebuild \
  -workspace "${WORKSPACE}" \
  -scheme "${SCHEME}" \
  -configuration Release \
  -archivePath "${ARCHIVE_PATH}" \
  -destination generic/platform=iOS \
  -allowProvisioningUpdates \
  clean archive

echo "[2/3] Exporting IPA..."
xcodebuild \
  -exportArchive \
  -archivePath "${ARCHIVE_PATH}" \
  -exportPath "${EXPORT_PATH}" \
  -exportOptionsPlist "${EXPORT_PLIST}" \
  -allowProvisioningUpdates

echo "[3/3] Done"
ls -lah "${EXPORT_PATH}"
echo "IPA path: ${EXPORT_PATH}"
