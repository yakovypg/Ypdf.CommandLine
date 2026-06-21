#!/usr/bin/env bash

set -euo pipefail

# Examples:
# ./container-run.sh --version
# ./container-run.sh render -i /input/pdf_with_images_and_text.pdf -o /output/pages_dir

if [[ $# -lt 1 ]]; then
  echo "error: command not specified" >&2
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MAIN_SCRIPT_PATH="$SCRIPT_DIR/run-docker-compose.sh"

"$MAIN_SCRIPT_PATH" run --rm ypdf-command-line "$@"
