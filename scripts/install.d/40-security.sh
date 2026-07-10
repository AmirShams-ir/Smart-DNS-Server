#!/usr/bin/env bash

set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "$0")" && pwd)"
LIB_DIR="$PROJECT_ROOT/lib"

source "$LIB_DIR/common.sh"

log_step "Applying security configuration"

cat >/etc/unbound/unbound.conf.d/security.conf <<EOF
server:

    hide-identity: yes
    hide-version: yes

    harden-glue: yes
    harden-dnssec-stripped: yes
    harden-short-bufsize: yes

    qname-minimisation: yes

    aggressive-nsec: yes

    unwanted-reply-threshold: 10000000

EOF

log_ok "Security configured"