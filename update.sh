#!/usr/bin/env bash
# ==============================================================================
#
# Smart DNS Server - Update Script
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

source "${BASE_DIR}/lib/common.sh"

###############################################################################
# Main
###############################################################################

main() {

    banner

    require_root

    require_os

    start_log

    info "Updating Smart DNS Server..."

    git pull --ff-only

    success "Project updated successfully."

    info "Running installer..."

    chmod +x ${BASE_DIR}/install.sh

    bash "${BASE_DIR}/install.sh"

}

main "$@"