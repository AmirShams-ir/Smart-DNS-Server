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
IFS=$'\n\t'

###############################################################################
# Base Directory
###############################################################################

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

###############################################################################
# Common Library
###############################################################################

source "${BASE_DIR}/lib/common.sh"
source "${BASE_DIR}/common.sh"
source "${BASE_DIR}/config.sh"
source "${BASE_DIR}/system.sh"
source "${BASE_DIR}/race.sh"
source "${BASE_DIR}/unbound.sh"

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

    for script in "$INSTALL_DIR"/*.sh
    do

        info "Executing $(basename "$script")"

        source "$script"

    done

    success ""
    success "Installation completed successfully."
    success ""

}

main "$@"