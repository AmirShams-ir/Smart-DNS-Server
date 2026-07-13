#!/usr/bin/env bash

set -euo pipefail

info "Disabling systemd-resolved"

if systemctl is-active --quiet systemd-resolved; then
    systemctl stop --now systemd-resolved
    systemctl disable --now systemd-resolved
fi
sleep 1

if [ -L /etc/resolv.conf ]; then
    rm -f /etc/resolv.conf
fi

cat >/etc/resolv.conf <<EOF
nameserver 127.0.0.1
options edns0 trust-ad
EOF

info "Testing configuration"

unbound-checkconf

info "Starting Unbound"

systemctl enable unbound
systemctl restart unbound

sleep 2

if systemctl is-active --quiet unbound; then
    success "Unbound service is running."
else
    fatal "Unbound service failed to start."
fi

success "Installation completed successfully"

info "Testing DNS resolver"

if dig +time=3 +tries=1 @127.0.0.1 google.com >/dev/null; then
    success "DNS resolver is working."
else
    fatal "DNS resolver test failed."
fi

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