#!/usr/bin/env bash
# ==============================================================================
#
# Smart DNS Server - Capture Script
#
# https://github.com/AmirShams-ir/Smart-DNS-Server
#
# Copyright (c) 2026 Amir Shams
# Licensed under Apache-2.0
#
# ==============================================================================


CAPTURE_ENGINE=""
CLIENT_IP=""

###########################################################
# Live DNS Monitor
###########################################################

monitor_menu() {

    choose_client || return

    clear

    echo
    echo "=========================================="
    echo " Live DNS Monitor"
    echo "=========================================="
    echo
    echo "Client : $CLIENT_IP"
    echo
    echo "Press Ctrl+C to stop."
    echo

    start_capture "$CLIENT_IP"

}

###########################################################
# Detect Capture Engine
###########################################################

detect_capture_engine() {

    if command -v tshark >/dev/null 2>&1; then
        CAPTURE_ENGINE="tshark"
        return 0
    fi

    echo
    echo "tshark is not installed."
    echo
    return 1

}

###########################################################
# Choose Client
###########################################################

choose_client() {

    detect_capture_engine || return 1

    echo
    echo "Searching active clients..."
    echo

    mapfile -t CLIENTS < <(
        ip neigh \
        | awk '$1 ~ /^[0-9]/ {print $1}' \
        | sort -u
    )

    [[ ${#CLIENTS[@]} -eq 0 ]] && {
        echo "No active clients found."
        return 1
    }

    PS3="Select Client: "

    select CLIENT_IP in "${CLIENTS[@]}" "Back"; do

        case "$CLIENT_IP" in

            Back)
                return 1
                ;;

            "")
                echo "Invalid selection."
                ;;

            *)
                monitor_menu
                ;;

        esac

    done

}

###########################################################
# Start Capture
###########################################################

start_capture() {

    local CLIENT="$1"
    local domain
    local last=""

tshark \
    -q \
    -l \
    -n \
    -p \
    -i any \
    -f "host $CLIENT and port 53" \
    -Y "dns.flags.response == 1" \
    -T fields \
    -E separator=$'\t' \
    -e dns.qry.name \
    -e dns.a \
    -e dns.aaaa |
    while IFS= read -r domain
    do
        [[ -z "$domain" ]] && continue

        [[ "$domain" == "$last" ]] && continue

        last="$domain"

        printf '%(%H:%M:%S)T   %s\n' -1 "$domain"
    done

}