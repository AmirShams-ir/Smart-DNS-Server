#!/usr/bin/env bash

###########################################################
# Live DNS Monitor
###########################################################

live_dns_monitor() {

    choose_client

    start_capture "$CLIENT_IP"

}

###########################################################
# Detect Capture Engine
###########################################################

detect_capture_engine() {

    if command -v tshark >/dev/null 2>&1; then
        CAPTURE_ENGINE="tshark"
        return
    fi

    if command -v tcpdump >/dev/null 2>&1; then
        CAPTURE_ENGINE="tcpdump"
        return
    fi

    echo
    echo "No packet capture program found."
    echo
    echo "Install one of:"
    echo
    echo "apt install tshark"
    echo "or"
    echo "apt install tcpdump"
    echo

    exit 1

}

###########################################################
# Detect Active Clients
###########################################################

choose_client() {

    detect_capture_engine

    echo
    echo "Searching active clients..."
    echo

    mapfile -t CLIENTS < <(

        ip neigh \
        | awk '$1 ~ /^[0-9]/ {print $1}' \
        | sort -u

    )

    if [[ ${#CLIENTS[@]} -eq 0 ]]; then

        echo "No active clients found."
        pause
        return

    fi

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

    clear

    echo
    echo "=========================================="
    echo " Live DNS Monitor"
    echo "=========================================="
    echo
    echo "Client : $CLIENT"
    echo
    echo "Press Ctrl+C to stop."
    echo

    if [[ "$CAPTURE_ENGINE" == "tcpdump" ]]; then

        tcpdump \
            -l \
            -nn \
            -i any \
            "host $CLIENT and port 53"

    else

        tshark \
            -l \
            -Y "ip.addr==$CLIENT && dns" \
            -i any

    fi

}