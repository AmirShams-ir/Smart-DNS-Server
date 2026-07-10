#!/usr/bin/env bash

set -euo pipefail

info "Creating Unbound directories"

mkdir -p /etc/unbound/unbound.conf.d
mkdir -p /var/lib/unbound
mkdir -p /var/log/unbound

chown unbound:unbound /var/lib/unbound
chown unbound:unbound /var/log/unbound

log_step "Downloading Root Hints"

curl -fsSL \
https://www.internic.net/domain/named.cache \
-o /var/lib/unbound/root.hints

unbound-anchor \
-a /var/lib/unbound/root.key

success "Unbound initialized"