#!/usr/bin/env bash

set -euo pipefail

info "Creating Unbound directories"

mkdir -p /etc/unbound/unbound.conf.d
mkdir -p /var/lib/unbound
mkdir -p /var/log/unbound

chown unbound:unbound /var/lib/unbound
chown unbound:unbound /var/log/unbound

info "Downloading Root Hints"

curl -fsSL \
https://www.internic.net/domain/named.cache \
-o /var/lib/unbound/root.hints

info "Generating DNSSEC root key..."

rm -f /var/lib/unbound/root.key

if unbound-anchor -a /var/lib/unbound/root.key; then
    success "DNSSEC root key generated."
else
    warning "Unbound-Anchor not generated."
fi

success "Unbound initialized"