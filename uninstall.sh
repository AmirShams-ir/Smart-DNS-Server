#!/usr/bin/env bash
# ==============================================================================
#
# Smart DNS Server - Uninstall Script
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
# Remove Service
###############################################################################

remove_services() {

    info "Removing services..."

    systemctl stop unbound 2>/dev/null || true

    systemctl disable unbound 2>/dev/null || true

}

###############################################################################
# Remove Packages
###############################################################################

remove_packages() {

    info "Removing packages..."

    apt remove -y unbound dnsutils

    apt autoremove -y

}

###############################################################################
# Remove Configuration
###############################################################################

remove_configuration() {

    info "Removing configuration..."

    rm -rf /etc/smartdns

    rm -rf /var/log/smartdns

}

###############################################################################
# Finish
###############################################################################

finish() {

    success "Smart DNS Server removed successfully."

}

###############################################################################
# Main
###############################################################################

main() {

    banner

    require_root

    require_os

    start_log

    remove_services

    remove_packages

    remove_configuration

    finish

}

main "$@"