#!/usr/bin/env bash

set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "$0")" && pwd)"
LIB_DIR="$PROJECT_ROOT/lib"

source "$LIB_DIR/common.sh"

info "Testing configuration"

unbound-checkconf

systemctl enable unbound

systemctl restart unbound

sleep 2

systemctl --no-pager --full status unbound

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