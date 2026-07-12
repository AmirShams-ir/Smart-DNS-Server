#!/usr/bin/env bash
# ==============================================================================
#
# Smart DNS Server - Unbound Script
#
# https://github.com/AmirShams-ir/Smart-DNS-Server
#
# Copyright (c) 2026 Amir Shams
# Licensed under Apache-2.0
#
# ==============================================================================

set -euo pipefail

###########################################################
# Files
###########################################################

FORWARD_CONF="${PROJECT_CONFIG_DIR}/forward.conf"

readonly TMP_FORWARD="$(mktemp -t smartdns-forward.XXXXXX)"

cleanup_forward() {

    rm -f "$TMP_FORWARD"

}

trap cleanup_forward EXIT

###########################################################
# Header
###########################################################

write_forward_header() {

cat > "$TMP_FORWARD" <<EOF
#
# ------------------------------------------------------------------
# Smart DNS Server
# Automatically generated
# Do NOT edit manually
# ------------------------------------------------------------------
#

forward-zone:
    name: "."
EOF

}

###########################################################
# Add Upstream Server
###########################################################

append_forward() {

    local SERVER="$1"

    echo "    forward-addr: $SERVER" >> "$TMP_FORWARD"

}

###########################################################
# Generate forward.conf
###########################################################

generate_forward() {

    info "Generating forward.conf"

    write_forward_header

    best_servers |

    while IFS='|' read -r SCORE AVG MIN MAX OK FAIL JITTER SERVER
    do

        append_forward "$SERVER"

    done

}

###########################################################
# Validate
###########################################################

validate_forward() {

    info "Validating Unbound configuration"

    unbound-checkconf

}

###########################################################
# Atomic Replace
###########################################################

install_forward() {

    install \
        -m 644 \
        "$TMP_FORWARD" \
        "$FORWARD_CONF" \
        /etc/unbound/unbound.conf.d/forward.conf

}

###########################################################
# Reload Unbound
###########################################################

reload_unbound_service() {

    info "Reloading Unbound"

    systemctl reload unbound

}

###########################################################
# Print Selected Servers
###########################################################

print_selected() {

printf "\n"

printf "Selected DNS Servers\n"

printf '%s\n' '----------------------------------------'

best_servers |

while IFS='|' read -r SCORE AVG MIN MAX OK FAIL JITTER SERVER
do

    printf "%-18s %4sms\n" \
        "$SERVER" \
        "$AVG"

done

printf "\n"

}

###########################################################
# Main
###########################################################

run_race() {

    benchmark_all

    print_header

    sort_results

    generate_forward

    install_forward

    validate_forward

    reload_unbound_service

    print_selected

    success "Race completed successfully."

}