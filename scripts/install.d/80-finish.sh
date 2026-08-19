#!/usr/bin/env bash

set -euo pipefail

info "Disabling systemd-resolved"

if systemctl is-active --quiet systemd-resolved; then
    systemctl disable --now systemd-resolved
fi

sleep 1

# /etc/resolv.conf can be managed by another service or marked immutable.
# Remove only a symlink that we can safely replace, and fail with a clear message
# instead of hiding an Operation not permitted error.
if [[ -L /etc/resolv.conf ]]; then
    rm -f /etc/resolv.conf || fatal "Cannot replace /etc/resolv.conf. Check its attributes with: lsattr /etc/resolv.conf"
fi

if [[ ! -e /etc/resolv.conf ]]; then
    if ! cat >/etc/resolv.conf <<EOF
nameserver 127.0.0.1
options edns0 trust-ad
EOF
    then
        fatal "Cannot create /etc/resolv.conf. Check: lsattr /etc/resolv.conf"
    fi
elif [[ -f /etc/resolv.conf ]]; then
    if ! grep -qE '^nameserver[[:space:]]+127\.0\.0\.1$' /etc/resolv.conf; then
        if ! cat >/etc/resolv.conf <<EOF
nameserver 127.0.0.1
options edns0 trust-ad
EOF
        then
            fatal "Cannot update /etc/resolv.conf. Check: lsattr /etc/resolv.conf"
        fi
    fi
else
    fatal "/etc/resolv.conf is not a regular file and cannot be managed safely."
fi

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

info "Configuring Automatic Rearm"

load_defaults
apply_rearm_timer

if [[ "$AUTO_REARM" == "yes" ]]; then
    systemctl enable --now rearm.timer
    systemctl enable --now rearm-boot.timer
    success "Automatic Rearm enabled (${AUTO_REARM_INTERVAL})."
else
    systemctl disable --now rearm.timer 2>/dev/null || true
    systemctl disable --now rearm-boot.timer 2>/dev/null || true
    success "Automatic Rearm disabled."
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
    ip -4 addr show "$DEFAULT_IFACE"     | awk '/inet /{print $2}'     | cut -d/ -f1     | head -n1
)

DNS_IPV6=$(
    ip -6 -o addr show dev "$DEFAULT_IFACE" scope global |
    awk '
        !/temporary/ &&
        !/deprecated/ &&
        !/tentative/ {
            split($4,a,"/");
            print a[1];
            exit
        }
    '
)

cat <<EOF

==================================
 Smart DNS Server is Ready
==================================

DNS Port : ${DNS_PORT}
Recursive : Enabled
DNSSEC    : ${DNSSEC}
Cache     : Enabled

Automatic Rearm : ${AUTO_REARM}
Rearm Interval  : ${AUTO_REARM_INTERVAL}

IPv4 DNS:
${DNS_IPV4:-Unavailable}

IPv6 DNS:
${DNS_IPV6:-Unavailable}

Now configure your router:

  IPv4 DNS : ${DNS_IPV4:-Unavailable}
  IPv6 DNS : ${DNS_IPV6:-Unavailable}

EOF
