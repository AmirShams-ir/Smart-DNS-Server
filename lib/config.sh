#!/usr/bin/env bash
# ==============================================================================
#
# Smart DNS Server - Config Script
#
# https://github.com/AmirShams-ir/Smart-DNS-Server
#
# Copyright (c) 2026 Amir Shams
# Licensed under Apache-2.0
#
# ==============================================================================

###########################################################
# Files Path
###########################################################

PROJECT_CONFIG_DIR="${BASE_DIR}/config"

GLOBAL_UPSTREAMS="${PROJECT_CONFIG_DIR}/upstreams-global.conf"
LOCAL_UPSTREAMS="${PROJECT_CONFIG_DIR}/upstreams-local.conf"

BLOCKLIST_FILE="${PROJECT_CONFIG_DIR}/blocklists.conf"
DEFAULTS_FILE="${PROJECT_CONFIG_DIR}/defaults.conf"


###########################################################
# Block Mode
###########################################################

block_mode() {

    local value

    value=$(
        grep -E "^BLOCK_MODE=" "$DEFAULTS_FILE" |
        cut -d= -f2 |
        tr '[:upper:]' '[:lower:]'
    )

    case "$value" in
        nxdomain|refuse|redirect|static)
            echo "$value"
            ;;
        *)
            echo "nxdomain"
            ;;
    esac
}

###########################################################
# Blocklist Reader
###########################################################

blocklist_enabled() {

    local category="$1"

    local value

    value=$(
        grep -E "^${category}=" "$BLOCKLIST_FILE" |
        cut -d= -f2 |
        tr '[:upper:]' '[:lower:]'
    )

    [[ "$value" == "enabled" ]]
}