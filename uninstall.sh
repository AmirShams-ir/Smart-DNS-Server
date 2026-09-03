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

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "${BASE_DIR}/config/blocklists.conf"
source "${BASE_DIR}/config/defaults.conf"
source "${BASE_DIR}/lib/common.sh"
source "${BASE_DIR}/lib/system.sh"

remove_services() {

    info "Removing services..."

    systemctl disable --now rearm.timer 2>/dev/null || true
    # Remove any timer left by older releases.
    systemctl disable --now rearm-boot.timer 2>/dev/null || true
    systemctl stop unbound 2>/dev/null || true
    systemctl disable unbound 2>/dev/null || true

}

remove_systemd_units() {

    info "Removing systemd units..."

    rm -f \
        /etc/systemd/system/rearm.service \
        /etc/systemd/system/rearm.timer \
        /etc/systemd/system/rearm-boot.timer

    rm -rf /etc/systemd/system/rearm.timer.d

    systemctl daemon-reload

}

remove_packages() {

    info "Removing packages..."

    apt-get remove -y unbound dnsutils || true
    apt-get autoremove -y || true

}

remove_configuration() {

    info "Removing configuration..."

    rm -rf /etc/smartdns
    rm -rf /var/log/smartdns
    rm -f /run/smartdns-rearm.lock

}

remove_resolv_conf_override() {

    info "Restoring /etc/resolv.conf..."

    # Do not delete a resolver configuration that was not created by us.
    if [[ -f /etc/resolv.conf ]] && grep -qE '^nameserver[[:space:]]+127\.0\.0\.1$' /etc/resolv.conf; then
        rm -f /etc/resolv.conf
        if command -v systemctl >/dev/null 2>&1 && systemctl list-unit-files systemd-resolved.service >/dev/null 2>&1; then
            systemctl enable --now systemd-resolved 2>/dev/null || true
        fi
    fi

}

finish() {

    success "Smart DNS Server removed successfully."

}

main() {

    banner
    require_root
    require_os
    start_log

    remove_services
    remove_systemd_units
    remove_configuration
    remove_resolv_conf_override
    remove_packages
    finish

}

main "$@"
