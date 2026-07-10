#!/usr/bin/env bash
set -euo pipefail

log_step "Selecting fastest upstream DNS servers"

"${SCRIPT_DIR}/race.sh"

log_ok "Best upstream resolvers selected"