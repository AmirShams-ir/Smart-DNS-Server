#!/usr/bin/env bash
# ==============================================================================
#
# Smart DNS Server - Installer Script
#
# https://github.com/AmirShams-ir/Smart-DNS-Server
#
# Copyright (c) 2026 Amir Shams
# Licensed under Apache-2.0
#
# ==============================================================================

set -Eeuo pipefail


###############################################################################
# Base Directory
###############################################################################

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

###############################################################################
# Common Library
###############################################################################

source "${BASE_DIR}/lib/blocklists.sh"
source "${BASE_DIR}/lib/common.sh"
source "${BASE_DIR}/lib/dns.sh"
source "${BASE_DIR}/lib/race.sh"
source "${BASE_DIR}/lib/system.sh"
source "${BASE_DIR}/lib/unbound.sh"

source "${BASE_DIR}/lib/ui.sh"
source "${BASE_DIR}/lib/core.sh"
source "${BASE_DIR}/lib/stats.sh"
source "${BASE_DIR}/lib/upstream.sh"
source "${BASE_DIR}/lib/dns-monitor.sh"
source "${BASE_DIR}/lib/block-manager.sh"
source "${BASE_DIR}/lib/config-manager.sh"
source "${BASE_DIR}/lib/rearm-manager.sh"

trap -p

###############################################################################
# Main
###############################################################################

main() {

    banner

    require_root

    require_os

    start_log

    info "Starting installation..."

    shopt -s nullglob

    local scripts=("${INSTALL_DIR}"/*.sh)

    if [[ ${#scripts[@]} -eq 0 ]]; then
        fatal "No installation modules found."
    fi

    for script in "$INSTALL_DIR"/*.sh; do

        info "Executing $(basename "$script")"

        if source "$script"; then
            success "$(basename "$script") completed"
        else
            fatal "$(basename "$script") failed (exit code $?)"
        fi

    done

    success ""
    success "Installation completed successfully."
    success ""

}

main "$@"