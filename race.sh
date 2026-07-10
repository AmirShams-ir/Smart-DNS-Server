#!/usr/bin/env bash

set -euo pipefail

###############################################################################
# Base Directory
###############################################################################

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

###############################################################################
# Common Library
###############################################################################

source "${BASE_DIR}/lib/common.sh"
source "${BASE_DIR}/lib/config.sh"
source "${BASE_DIR}/lib/system.sh"
source "${BASE_DIR}/lib/race.sh"
source "${BASE_DIR}/lib/unbound.sh"

run_race

log_ok "Best upstream resolvers selected"