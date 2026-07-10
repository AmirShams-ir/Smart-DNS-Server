#!/usr/bin/env bash

set -euo pipefail

info "Testing configuration"

unbound-checkconf

systemctl enable unbound

systemctl restart unbound

sleep 2

if systemctl is-active --quiet unbound; then
    success "Unbound service is running."
else
    fatal "Unbound service failed to start."
fi

success "Installation completed successfully"

echo
echo "--------------------------------------------"
echo " Smart DNS Server Installed Successfully"
echo "--------------------------------------------"
echo
echo "DNS Port : 53"
echo "Recursive : Enabled"
echo "DNSSEC    : Enabled"
echo "Cache     : Enabled"
echo "Ready."
echo