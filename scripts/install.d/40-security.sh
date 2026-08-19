#!/usr/bin/env bash

set -euo pipefail

info "Applying security configuration"

security_bool() {
    case "${1:-no}" in
        yes|true|on|1) echo yes ;;
        *) echo no ;;
    esac
}

cat >/etc/unbound/unbound.conf.d/security.conf <<EOF
server:

    hide-identity: $(security_bool "$HIDE_IDENTITY")
    hide-version: $(security_bool "$HIDE_VERSION")

    harden-glue: yes
    harden-dnssec-stripped: yes
    harden-short-bufsize: yes

    qname-minimisation: $(security_bool "$QNAME_MINIMISATION")

    aggressive-nsec: yes

    unwanted-reply-threshold: 10000000

EOF

# Keep DNSSEC configuration declarative and idempotent. The legacy duplicate
# trust-anchor fragment is removed before the canonical file is generated.
rm -f /etc/unbound/unbound.conf.d/root-auto-trust-anchor-file.conf

case "${DNSSEC:-no}" in
    yes|true|on|1)
        cat >/etc/unbound/unbound.conf.d/dnssec.conf <<EOF
server:

    auto-trust-anchor-file: "/var/lib/unbound/root.key"
    harden-dnssec-stripped: yes
    harden-algo-downgrade: yes
    val-clean-additional: yes

EOF
        ;;
    *)
        rm -f /etc/unbound/unbound.conf.d/dnssec.conf
        ;;
esac

success "Security configured"
