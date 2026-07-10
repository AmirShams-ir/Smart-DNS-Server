#!/usr/bin/env bash

set -euo pipefail

info "Race upstream resolvers"

source "$LIB_DIR/common.sh"
source "$LIB_DIR/config.sh"
source "$LIB_DIR/system.sh"
source "$LIB_DIR/race.sh"
source "$LIB_DIR/unbound.sh"

run_race

success "Best upstream resolvers selected"