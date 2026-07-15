#!/usr/bin/env bash

set -Eeuo pipefail


###############################################################################
# Base Directory
###############################################################################

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

###############################################################################
# Libraries
###############################################################################

source "${BASE_DIR}/lib/common.sh"
source "${BASE_DIR}/lib/config.sh"
source "${BASE_DIR}/lib/dns.sh"
source "${BASE_DIR}/lib/race.sh"
source "${BASE_DIR}/lib/system.sh"
source "${BASE_DIR}/lib/unbound.sh"

trap -p

###############################################################################
# Main
###############################################################################

info "Generating new Unbound configuration..."

run_race

###############################################################################
# Test DNS Resolver
###############################################################################

info "Testing DNS resolver"

if dig +time=3 +tries=1 @127.0.0.1 google.com >/dev/null; then
    success "DNS resolver is working."
else
    fatal "DNS resolver test failed."
fi

###############################################################################
# Detect Network Interface
###############################################################################

DEFAULT_IFACE=$(ip route | awk '/default/ {print $5; exit}')

###############################################################################
# IPv4 Address
###############################################################################

DNS_IPV4=$(
    ip -4 addr show "$DEFAULT_IFACE" |
    awk '/inet / {print $2}' |
    cut -d/ -f1
)

###############################################################################
# IPv6 Address
###############################################################################

DNS_IPV6=$(
    ip -6 -o addr show dev "$DEFAULT_IFACE" scope global |
    awk '
        !/temporary/ &&
        !/deprecated/ &&
        !/tentative/ {
            split($4,a,"/");
            print a[1];
            exit
        }
    '
)

###############################################################################
# Summary
###############################################################################

echo "========================================"
success "Smart DNS Server rearmed successfully."
echo "========================================"

cat <<EOF

DNS Port  : 53
Recursive : Enabled
DNSSEC    : Enabled
Cache     : Enabled

IPv4 DNS:
${DNS_IPV4}

IPv6 DNS:
${DNS_IPV6}

Now configure your router:

  IPv4 DNS : ${DNS_IPV4}
  IPv6 DNS : ${DNS_IPV6}

EOF