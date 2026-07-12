#!/usr/bin/env bash

set -euo pipefail


info "Detect LAN Network"

LAN_NETWORK="$(
ip -4 route |
awk '/proto kernel/ && $1 != "127.0.0.0/8" {print $1; exit}'
)"


: "${LAN_NETWORK:=192.168.1.0/24}"

success "Detected LAN: ${LAN_NETWORK}"

info "Creating Resolver configuration"

cat >/etc/unbound/unbound.conf.d/resolver.conf <<EOF
server:

    interface: 0.0.0.0
    interface: ::0

    port: 53

    do-ip4: yes
    do-ip6: yes

    do-udp: yes
    do-tcp: yes

    access-control: 127.0.0.0/8 allow
    access-control: ::1 allow
    access-control: ${LAN_NETWORK} allow

    root-hints: "/var/lib/unbound/root.hints"

    verbosity: 1

EOF

success "Resolver configured"