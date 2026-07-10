#!/usr/bin/env bash

set -euo pipefail

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