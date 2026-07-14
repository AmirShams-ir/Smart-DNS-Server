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

DEFAULT_IFACE=$(ip route | awk '/default/ {print $5; exit}')

DNS_IPV4=$(
    ip -4 addr show "$DEFAULT_IFACE" \
    | awk '/inet /{print $2}' \
    | cut -d/ -f1
)

DNS_IPV6=$(
    ip -6 addr show dev "$DEFAULT_IFACE" \
    | awk '
        /scope global/ &&
        !/temporary/ &&
        !/deprecated/ &&
        !/tentative/
        {
            split($2,a,"/");
            print a[1];
            exit
        }
    '
)

cat <<EOF

==================================
 Smart DNS Server is Ready
==================================

DNS Port : 53
Recursive : Enabled
DNSSEC    : Enabled
Cache     : Enabled

IPv4 DNS:
${DNS_IPV4}

IPv6 DNS:
${DNS_IPV6}

Now configure your router:

  IPv4 DNS : ${DNS_IPV4}
  IPv6 DNS : ${DNS_IPV6}

EOF