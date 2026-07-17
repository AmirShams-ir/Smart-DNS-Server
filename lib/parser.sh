#!/usr/bin/env bash

###########################################################
# Live DNS Monitor
###########################################################

live_dns_monitor() {

    choose_client

    start_capture "$CLIENT_IP"

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

    awk '

    BEGIN {

        OFS="\t"

    }

    /Standard query/ && $0 !~ /response/ {

        domain=""

        for(i=1;i<=NF;i++){

            if($i=="A" || $i=="AAAA" || $i=="HTTPS" || $i=="SVCB" || $i=="CNAME"){

                domain=$(i+1)
                break

            }

        }

        if(domain=="")
            next

        sub(/\.Home$/,"",domain)

        if(seen[domain]++)
            next

        printf "%s   %s\n",
            strftime("%H:%M:%S"),
            domain

        fflush()

    }

    '

}