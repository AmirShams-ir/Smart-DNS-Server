#!/usr/bin/env bash
# ==============================================================================
#
# Smart DNS Server - Race Engine
#
# https://github.com/AmirShams-ir/Smart-DNS-Server
#
# Copyright (c) 2026 Amir Shams
# Licensed under Apache-2.0
#
# ==============================================================================

set -euo pipefail

###########################################################
# Default Configuration
###########################################################

: "${DNS_TEST_DOMAIN:=.}"
: "${DNS_QUERY_TYPE:=NS}"

: "${DNS_TIMEOUT:=2}"
: "${DNS_RETRIES:=1}"
: "${DNS_TEST_COUNT:=3}"

: "${TOP_SERVERS:=3}"

: "${LATENCY_WEIGHT:=1}"
: "${FAIL_WEIGHT:=100}"
: "${JITTER_WEIGHT:=1}"

readonly TMP_RESULTS="$(mktemp)"

###########################################################
# Cleanup
###########################################################

cleanup() {

    rm -f "$TMP_RESULTS"

}

trap cleanup EXIT

###########################################################
# IPv4 Validation
###########################################################

valid_ipv4() {

    local ip="$1"

    [[ "$ip" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]] || return 1

    IFS='.' read -r a b c d <<< "$ip"

    for n in "$a" "$b" "$c" "$d"
    do
        (( n >= 0 && n <= 255 )) || return 1
    done

}

###########################################################
# IPv6 Validation
###########################################################

valid_ipv6() {

    local ip="$1"

    # Fast check
    [[ "$ip" == *:* ]] || return 1

    # Preferred: use iproute2
    if command -v ip >/dev/null 2>&1
    then
        ip -6 route get "$ip" >/dev/null 2>&1
        return $?
    fi

    # Fallback regex
    [[ "$ip" =~ ^[0-9A-Fa-f:]+$ ]]

}

###########################################################
# Generic IP Validation
###########################################################

valid_ip() {

    valid_ipv4 "$1" || valid_ipv6 "$1"

}

###########################################################
# DNS Query
###########################################################

query_time() {

    local server="$1"

    dig @"$server" \
        "$DNS_TEST_DOMAIN" \
        "$DNS_QUERY_TYPE" \
        +tries="$DNS_RETRIES" \
        +time="$DNS_TIMEOUT" \
        +stats \
        2>/dev/null |
        awk '/Query time:/ {print $4}'

}

###########################################################
# Read Upstream Files
###########################################################

load_servers() {

        cat "$GLOBAL_UPSTREAMS" "$LOCAL_UPSTREAMS" 2>/dev/null |
        while IFS='|' read -r NAME TYPE PRIMARY SECONDARY
        do

        [[ -z "$NAME" ]] && continue

        [[ "$NAME" =~ ^# ]] && continue

        [[ "$TYPE" != "udp" ]] && continue

        if [[ -n "$PRIMARY" ]]; then
            valid_ip "$PRIMARY" && echo "$PRIMARY"
        fi

        if [[ -n "$SECONDARY" ]]; then
            valid_ip "$SECONDARY" && echo "$SECONDARY"
        fi

    done

}

###########################################################
# Remove duplicate servers
###########################################################

unique_servers() {

    load_servers |
    sort -u

}

###########################################################
# Count servers
###########################################################

server_count() {

    unique_servers |
    wc -l

}

###########################################################
# Pretty Header
###########################################################

print_header() {

printf "\n"

printf "%-16s %-8s %-8s %-8s %-8s %-8s %-8s\n" \
"SERVER" \
"SCORE" \
"AVG" \
"MIN" \
"MAX" \
"OK" \
"LOSS"

printf "%-16s %-8s %-8s %-8s %-8s %-8s %-8s\n" \
"------" \
"-----" \
"---" \
"---" \
"---" \
"--" \
"----"

}

###########################################################
# Save Result
###########################################################

save_result() {

    echo "$1" >> "$TMP_RESULTS"

}

###########################################################
# Benchmark One DNS Server
###########################################################

benchmark_server() {

    local SERVER="$1"

    local SUCCESS=0
    local FAIL=0

    local SUM=0
    local MIN=999999
    local MAX=0

    local LAST=0
    local JITTER=0

    local QUERY_TIME
    local TOTAL="$DNS_TEST_COUNT"

    for ((i=1; i<=DNS_TEST_COUNT; i++))
    do

        QUERY_TIME="$(query_time "$SERVER")"

        if [[ -z "$QUERY_TIME" ]]
        then
            ((FAIL++))
            continue
        fi

        ((SUCCESS++))

        SUM=$((SUM + QUERY_TIME))

        (( QUERY_TIME < MIN )) && MIN=$QUERY_TIME
        (( QUERY_TIME > MAX )) && MAX=$QUERY_TIME

        if (( LAST > 0 ))
        then

            local DIFF=$((QUERY_TIME-LAST))

            (( DIFF < 0 )) && DIFF=$((-DIFF))

            JITTER=$((JITTER+DIFF))

        fi

        LAST=$QUERY_TIME

    done

    [[ $SUCCESS -eq 0 ]] && return

    local AVG=$((SUM/SUCCESS))

    if (( SUCCESS > 1 ))
    then
        JITTER=$((JITTER/(SUCCESS-1)))
    else
        JITTER=0
    fi

    calculate_score \
        "$SERVER" \
        "$AVG" \
        "$MIN" \
        "$MAX" \
        "$SUCCESS" \
        "$FAIL" \
        "$JITTER"

}

###########################################################
# Score Algorithm
###########################################################

calculate_score() {

    local SERVER="$1"

    local AVG="$2"
    local MIN="$3"
    local MAX="$4"

    local SUCCESS="$5"
    local FAIL="$6"

    local JITTER="$7"

    #######################################################
    # Score Point (Lower is Better)
    #######################################################

    local SCORE=0

    SCORE=$(( AVG * LATENCY_WEIGHT ))

    SCORE=$(( SCORE + FAIL * FAIL_WEIGHT ))

    SCORE=$(( SCORE + JITTER * JITTER_WEIGHT ))

    save_result \
    "$SCORE|$AVG|$MIN|$MAX|$SUCCESS|$FAIL|$JITTER|$SERVER"

}

###########################################################
# Benchmark All Servers
###########################################################

benchmark_all() {

    info "Testing DNS servers..."

    unique_servers |

    while read -r SERVER
    do

        valid_ip "$SERVER" || continue

        benchmark_server "$SERVER"

    done

}

###########################################################
# Sort Results
###########################################################

sort_results() {

    sort \
        -t'|' \
        -k1,1n \
        -k2,2n \
        "$TMP_RESULTS"

}

###########################################################
# Select Best Servers
###########################################################

best_servers() {

    sort_results |

    head -n "$TOP_SERVERS"

}