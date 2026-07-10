#!/usr/bin/env bash

set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "$0")" && pwd)"
LIB_DIR="$PROJECT_ROOT/lib"

source "$LIB_DIR/common.sh"

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