#!/usr/bin/env bash

set -euo pipefail

# Examples:
# ./run-docker-compose.sh up -d --build
# ./run-docker-compose.sh down

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOCKER_COMPOSE_PATH="$SCRIPT_DIR/docker-compose.yml"
ENV_PATH="$SCRIPT_DIR/.env"

docker compose -f "$DOCKER_COMPOSE_PATH" --env-file "$ENV_PATH" "$@"
