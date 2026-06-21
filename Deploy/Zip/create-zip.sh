#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# -------- Parameter constants (edit these) --------
CSPROJ_PATH="$SCRIPT_DIR/../../Application/Ypdf.CommandLine/Ypdf.CommandLine.csproj"

APP_NAME="ypdf"                 # Application name
APP_VERSION="2.0.0"             # Application version
PUBLISH_CONFIG="Release"        # Configuration
PUBLISH_FRAMEWORK="net10.0"     # Target framework
PUBLISH_RUNTIME_ID="linux-x64"  # Runtime identifier
PUBLISH_SELF_CONTAINED="true"   # Publish as self-contained application

# -------- Internal directories --------
OUT_DIR="$SCRIPT_DIR"                                   # Output directory for the resulting .zip
PUBLISH_DIR="$(mktemp -d)/${APP_NAME}_${APP_VERSION}"   # Publish directory

if [ ! -d "$OUT_DIR" ]; then
    mkdir -p "$OUT_DIR"
fi

# -------- Remove temp directories --------
cleanup() {
  rm -rf "$PUBLISH_DIR"
}

trap cleanup EXIT

# -------- Publish application --------
if [ ! -f "$CSPROJ_PATH" ]; then
  echo "error: .csproj not found: $CSPROJ_PATH" >&2
  exit 1
fi

dotnet publish \
    "$CSPROJ_PATH" \
    --configuration "$PUBLISH_CONFIG" \
    --framework "$PUBLISH_FRAMEWORK" \
    --runtime "$PUBLISH_RUNTIME_ID" \
    --self-contained "$PUBLISH_SELF_CONTAINED" \
    --output "$PUBLISH_DIR"

# -------- Build zip --------
ZIP_PATH="$OUT_DIR/${APP_NAME}_${APP_VERSION}.zip"
PUBLISH_PARENT_DIR="$(dirname "$PUBLISH_DIR")"
ZIP_ROOT="$(basename "$PUBLISH_DIR")"

(
  cd "$PUBLISH_PARENT_DIR"
  zip -r "$ZIP_PATH" "$ZIP_ROOT"
)

# -------- Print summary --------
echo
echo "Built: $ZIP_PATH"
