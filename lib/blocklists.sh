#!/usr/bin/env bash
# ==============================================================================
#
# Smart DNS Server - BlockLists Script
#
# https://github.com/AmirShams-ir/Smart-DNS-Server
#
# Copyright (c) 2026 Amir Shams
# Licensed under Apache-2.0
#
# ==============================================================================

###########################################################
# Files
###########################################################

readonly BLOCK_CONF="/etc/unbound/unbound.conf.d/blocklists.conf"

readonly TMP_BLOCK="$(mktemp -t smartdns-block.XXXXXX)"

cleanup_forward() {

    rm -f "$TMP_FORWARD"

}

###########################################################
# Header
###########################################################

write_block_header() {

cat > "$TMP_BLOCK" <<EOF
#
# ----------------------------------------------------------
# Smart DNS Server
# Automatically generated
# Do NOT edit manually
# ----------------------------------------------------------
#

server:

EOF

}

###########################################################
# Add Domain
###########################################################

append_domain() {

    local DOMAIN="$1"

    [[ -z "$DOMAIN" ]] && return

    [[ "$DOMAIN" =~ ^# ]] && return

    cat >> "$TMP_BLOCK" <<EOF
    local-zone: "$DOMAIN." always_nxdomain
EOF

}

###########################################################
# Process Blocklist
###########################################################

process_blocklist() {

    local FILE="$1"

    while IFS= read -r DOMAIN
    do

        DOMAIN="${DOMAIN%%#*}"

        DOMAIN="$(echo "$DOMAIN" | xargs)"

        append_domain "$DOMAIN"

    done < "$FILE"

}

###########################################################
# Generate Blocklists
###########################################################

generate_blocklists() {

    info "Generating Blocklists"

    write_block_header

    for DIR in "$BASE_DIR"/blocklists/*
    do

        [[ -d "$DIR" ]] || continue

        CATEGORY=$(basename "$DIR")

        if blocklist_enabled "$CATEGORY"
        then

            info "Loading $CATEGORY"

            find "$DIR" -type f -name "*.txt" | sort |

            while IFS= read -r FILE
            do

                info "  $(basename "$FILE")"

                process_blocklist "$FILE"

            done

        fi

    done

}

###########################################################
# Install
###########################################################

install_blocklists() {

    install \
        -m 644 \
        "$TMP_BLOCK" \
        "$BLOCK_CONF"

}