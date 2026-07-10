#!/usr/bin/env bash

set -euo pipefail

log_step "Forward configuration"

cat >/etc/unbound/unbound.conf.d/forward.conf <<EOF
# Empty.

# Future versions will automatically
# generate forward-zone entries
# using the SmartDNS Race Engine.

EOF

log_ok "Forward configuration ready"