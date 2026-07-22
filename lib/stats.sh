#!/usr/bin/env bash

stats_menu() {

    clear

    echo "=================================================="
    echo "                  Statistics"
    echo "=================================================="
    echo

    print_dns_status

    echo

    print_cache_stats

    echo

    print_block_stats

    echo

    print_system_stats

    echo

    pause

}

print_dns_status() {

    local DNS_STATUS
    local TIMER_STATUS
    local TIMER_INTERVAL

    DNS_STATUS=$(systemctl is-active unbound 2>/dev/null)

    TIMER_STATUS=$(systemctl is-enabled rearm.timer 2>/dev/null)

    TIMER_INTERVAL=$(config_get AUTO_REARM_INTERVAL)

    printf "%-20s %s\n" \
        "DNS Service" \
        "$(status_text "$DNS_STATUS")"

    printf "%-20s %s\n" \
        "Auto Rearm" \
        "$(status_text "$TIMER_STATUS")"
        
    printf "%-20s %s\n" "Interval" "$TIMER_INTERVAL"

}

print_cache_stats() {

    if ! command -v unbound-control >/dev/null 2>&1
    then
        return
    fi

    local QUERIES
    local HITS

    QUERIES=$(
        unbound-control stats_noreset |
        grep '^total.num.queries=' |
        cut -d= -f2
    )

    HITS=$(
        unbound-control stats_noreset |
        grep '^total.num.cachehits=' |
        cut -d= -f2
    )

    printf "%-20s %s\n" "Queries" "$QUERIES"
    printf "%-20s %s\n" "Cache Hits" "$HITS"

}

print_block_stats() {

    local FILES
    local DOMAINS
    local CATEGORIES

    FILES=$(
        find "$BASE_DIR/blocklists" \
        -type f \
        -name "*.txt" |
        wc -l
    )

    DOMAINS=$(
        find "$BASE_DIR/blocklists" \
        -type f \
        -name "*.txt" \
        -exec cat {} + |
        grep -v '^#' |
        grep -v '^$' |
        wc -l
    )

    CATEGORIES=$(
        find "$BASE_DIR/blocklists" \
        -mindepth 1 \
        -maxdepth 1 \
        -type d |
        wc -l
    )

    printf "%-20s %s\n" "Categories" "$CATEGORIES"
    printf "%-20s %s\n" "Files" "$FILES"
    printf "%-20s %s\n" "Domains" "$DOMAINS"

}

print_system_stats() {

    local MEM
    local DISK
    local LOAD
    local UPTIME

    MEM=$(free -h |
        awk '/Mem:/ {print $3 " / " $2}')

    DISK=$(df -h / |
        awk 'NR==2 {print $3 " / " $2}')

    LOAD=$(uptime |
        awk -F'load average:' '{print $2}' |
        cut -d',' -f1 |
        xargs)

    UPTIME=$(uptime -p)

    printf "%-20s %s\n" "Memory" "$MEM"
    printf "%-20s %s\n" "Disk" "$DISK"
    printf "%-20s %s\n" "Load" "$LOAD"
    printf "%-20s %s\n" "Uptime" "$UPTIME"

}

status_text() {

    case "$1" in
        active)    echo "Running" ;;
        inactive)  echo "Stopped" ;;
        enabled)   echo "Enabled" ;;
        disabled)  echo "Disabled" ;;
        failed)    echo "Failed" ;;
        *)         echo "$1" ;;
    esac

}

