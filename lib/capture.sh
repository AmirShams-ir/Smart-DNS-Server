#!/usr/bin/env bash

#
# Smart DNS Server
# Capture Library
#

CAPTURE_ENGINE=""
CLIENT_IP=""

###########################################################
# Live DNS Monitor
###########################################################

live_dns_monitor() {

    choose_client || return

    clear

    echo
    echo "=========================================="
    echo "          Live DNS Monitor"
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

    if command -v tcpdump >/dev/null 2>&1; then
        CAPTURE_ENGINE="tcpdump"
        return 0
    fi

    echo
    echo "No capture engine found."
    echo
    echo "Install one of:"
    echo
    echo "    apt install tshark"
    echo "or"
    echo "    apt install tcpdump"
    echo

    return 1

}

###########################################################
# Choose Client
###########################################################

choose_client() {

    detect_capture_engine || return 1

    mapfile -t CLIENTS < <(

        ip neigh \
        | awk '{print $1}' \
        | grep -E '^(192\.168\.|10\.|172\.(1[6-9]|2[0-9]|3[0-1])\.)' \
        | sort -u

    )

    if [[ ${#CLIENTS[@]} -eq 0 ]]; then

        echo
        echo "No active clients found."
        pause
        return 1

    fi

    echo
    echo "Available Clients"
    echo "-----------------"

    PS3="Select Client: "

    select CLIENT_IP in "${CLIENTS[@]}"; do

        [[ -n "$CLIENT_IP" ]] && break

    done

}

###########################################################
# Start Capture
###########################################################

start_capture() {

    local CLIENT="$1"

    if [[ "$CAPTURE_ENGINE" == "tcpdump" ]]; then

        tcpdump \
            -l \
            -n \
            -i any \
            "host $CLIENT and port 53"

    else

        tshark \
            -l \
            -n \
            -p \
            -i any \
            -f "port 53" \
        | parse_dns

    fi

}