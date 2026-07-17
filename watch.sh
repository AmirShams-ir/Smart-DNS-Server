#!/usr/bin/env bash
# ==============================================================================
#
# Smart DNS Server - Watch DNS Script
#
# https://github.com/AmirShams-ir/Smart-DNS-Server
#
# Copyright (c) 2026 Amir Shams
# Licensed under Apache-2.0
#
# ==============================================================================

set -Eeuo pipefail

LOG="/var/log/unbound.log"

clear
echo "==============================="
echo " Smart DNS Live Monitor"
echo "==============================="

clients=$(grep "query:" "$LOG" \
    | awk '{print $NF}' \
    | cut -d'#' -f1 \
    | sort -u)

if [ -z "$clients" ]; then
    echo
    echo "No DNS clients found."
    exit 1
fi

echo

select IP in $clients; do

    [ -z "$IP" ] && continue

    echo
    echo "Watching client $IP"
    echo "Press Ctrl+C to stop."
    echo

    tail -Fn0 "$LOG" | \
    awk -v ip="$IP" '
        /query:/ {

            client=$NF
            sub(/#.*/,"",client)

            if(client==ip){

                time=$2
                type=$8
                host=$9

                printf "%s %-6s %s\n",time,type,host
                fflush()

            }

        }'

done