#!/usr/bin/env bash

set -euo pipefail

log_step "Creating Resolver configuration"

cat >/etc/unbound/unbound.conf.d/resolver.conf <<EOF
server:

    interface: 0.0.0.0
    interface: ::0

    port: 53

    do-ip4: yes
    do-ip6: yes

    do-udp: yes
    do-tcp: yes

    root-hints: "/var/lib/unbound/root.hints"

    auto-trust-anchor-file: "/var/lib/unbound/root.key"

EOF

log_ok "Resolver configured"