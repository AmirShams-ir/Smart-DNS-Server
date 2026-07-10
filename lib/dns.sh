#!/usr/bin/env bash
# ==============================================================================
#
# Smart DNS Server - DNS Script
#
# https://github.com/AmirShams-ir/Smart-DNS-Server
#
# Copyright (c) 2026 Amir Shams
# Licensed under Apache-2.0
#
# ==============================================================================

query_dns(){

    local SERVER="$1"

    dig @"$SERVER" \
        google.com \
        +tries=1 \
        +time=2 \
        +stats

}

measure_dns(){

    local SERVER="$1"

    dig @"$SERVER" \
        google.com \
        +tries=1 \
        +time=2 \
        +stats \
        2>/dev/null |
        awk '/Query time/ {print $4}'

}

dns_alive(){

    local SERVER="$1"

    dig @"$SERVER" \
        google.com \
        +tries=1 \
        +time=2 \
        +short \
        >/dev/null

}