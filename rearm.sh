#!/usr/bin/env bash

set -euo pipefail

###############################################################################
# Base Directory
###############################################################################

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

###############################################################################
# Libraries
###############################################################################

source "${BASE_DIR}/lib/common.sh"
source "${BASE_DIR}/lib/config.sh"
source "${BASE_DIR}/lib/system.sh"
source "${BASE_DIR}/lib/race.sh"
source "${BASE_DIR}/lib/unbound.sh"

###############################################################################
# Main
###############################################################################

print_header

info "Benchmarking upstream DNS servers..."

benchmark_all

info "Generating new Unbound configuration..."

generate_forward

install_forward

validate_forward

reload_unbound_service

print_selected

success "Smart DNS Server rearmed successfully."