#!/usr/bin/env bash
# ==============================================================================
#
# Smart DNS Server - Panel Script
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

trap -p

###############################################################################
# Main
###############################################################################

info "Smart DNS Panel"

set -Eeuo pipefail

main() {

    require_root

    main_menu

}

main "$@"