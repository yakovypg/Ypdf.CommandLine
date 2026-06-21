#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MAIN_SCRIPT_PATH="$SCRIPT_DIR/run-docker-compose.sh"

"$MAIN_SCRIPT_PATH" build
