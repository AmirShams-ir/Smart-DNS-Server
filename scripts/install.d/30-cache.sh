#!/usr/bin/env bash

set -euo pipefail

log_step "Configuring DNS Cache"

cat >/etc/unbound/unbound.conf.d/cache.conf <<EOF
server:

    msg-cache-size: 64m
    rrset-cache-size: 128m

    cache-min-ttl: 300
    cache-max-ttl: 86400

    prefetch: yes
    prefetch-key: yes

    serve-expired: yes
    serve-expired-ttl: 86400

EOF

log_ok "Cache configured"