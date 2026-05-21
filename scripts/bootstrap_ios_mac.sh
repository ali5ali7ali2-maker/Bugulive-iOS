#!/usr/bin/env bash
set -euo pipefail

# BuguLive iOS bootstrap script for macOS
# Usage: bash scripts/bootstrap_ios_mac.sh

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

echo "[1/7] Checking macOS tools..."
if ! command -v xcodebuild >/dev/null 2>&1; then
  echo "ERROR: xcodebuild not found. Install Xcode first."
  exit 1
fi

if ! command -v ruby >/dev/null 2>&1; then
  echo "ERROR: ruby not found. Install Ruby (brew install ruby) and re-run."
  exit 1
fi

echo "[2/7] Ensuring CocoaPods is available..."
if ! command -v pod >/dev/null 2>&1; then
  echo "CocoaPods not found. Installing..."
  gem install cocoapods
fi

echo "[3/7] CocoaPods version: $(pod --version)"

echo "[4/7] Cleaning previous Pod integration (safe reset)..."
pod deintegrate || true
rm -rf Pods
rm -f Podfile.lock

echo "[5/7] Updating pod specs and installing pods..."
pod repo update
pod install --repo-update

echo "[6/7] Listing available schemes..."
xcodebuild -workspace BuguLive.xcworkspace -list

echo "[7/7] Bootstrap complete."
echo "Next: run build script -> bash scripts/build_ios_debug.sh"
