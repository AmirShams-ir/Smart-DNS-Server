#!/usr/bin/env bash

set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "$0")" && pwd)"
LIB_DIR="$PROJECT_ROOT/lib"

source "$LIB_DIR/common.sh"
source "$LIB_DIR/config.sh"
source "$LIB_DIR/system.sh"
source "$LIB_DIR/race.sh"
source "$LIB_DIR/unbound.sh"

run_race

log_ok "Best upstream resolvers selected"