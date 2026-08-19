#!/usr/bin/env bash

set -euo pipefail

info "Configuring DNS Cache"

cache_bool() {
    case "${1:-no}" in
        yes|true|on|1) echo yes ;;
        *) echo no ;;
    esac
}

cat >/etc/unbound/unbound.conf.d/cache.conf <<EOF
server:

    msg-cache-size: ${CACHE_MSG_SIZE}
    rrset-cache-size: ${CACHE_RRSET_SIZE}

    cache-min-ttl: ${CACHE_MIN_TTL}
    cache-max-ttl: ${CACHE_MAX_TTL}

    prefetch: $(cache_bool "$PREFETCH")
    prefetch-key: $(cache_bool "$PREFETCH")

    serve-expired: $(cache_bool "$SERVE_EXPIRED")
    serve-expired-ttl: 86400

EOF

# Unbound expects a numeric value for num-threads. "auto" means leave the
# directive unset and let Unbound use its normal default.
if [[ "$THREADS" =~ ^[1-9][0-9]*$ ]]; then
    printf '    num-threads: %s
' "$THREADS" >> /etc/unbound/unbound.conf.d/cache.conf
fi

success "Cache configured"
