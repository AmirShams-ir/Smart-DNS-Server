#!/usr/bin/env bash
# ==============================================================================
#
# Smart DNS Server - Rearm Manager
#
# Keeps the user configuration and the single systemd Rearm timer synchronized.
#
# ===============================================================================

REARM_TIMER_UNIT="/etc/systemd/system/rearm.timer"

###############################################################################
# Validate Rearm Interval
###############################################################################

validate_rearm_interval() {

    local interval="${1:-}"
    local value
    local unit

    [[ "$interval" =~ ^([1-9][0-9]*)(m|min|h|d)$ ]] || return 1

    value="${BASH_REMATCH[1]}"
    unit="${BASH_REMATCH[2]}"

    case "$unit" in
        m|min)
            (( value >= 1 && value <= 35791394 )) || return 1
            ;;
        h)
            (( value >= 1 && value <= 596523 )) || return 1
            ;;
        d)
            (( value >= 1 && value <= 24855 )) || return 1
            ;;
    esac

}

###############################################################################
# Write Rearm Timer
###############################################################################

write_rearm_timer() {

    local interval="$1"

    cat > "$REARM_TIMER_UNIT" <<EOF_TIMER
[Unit]
Description=Automatic Smart DNS Rearm
After=network-online.target
Wants=network-online.target

[Timer]
OnUnitActiveSec=${interval}
AccuracySec=1min
Unit=rearm.service

[Install]
WantedBy=timers.target
EOF_TIMER

}

###############################################################################
# Apply Rearm Interval To systemd
###############################################################################

apply_rearm_timer() {

    load_defaults

    validate_rearm_interval "$AUTO_REARM_INTERVAL" || {
        warning "Invalid AUTO_REARM_INTERVAL: $AUTO_REARM_INTERVAL"
        return 1
    }

    if [[ ! -f "$REARM_TIMER_UNIT" ]]; then
        warning "rearm.timer is not installed yet."
        return 0
    fi

    info "Applying Rearm interval: ${AUTO_REARM_INTERVAL}"

    write_rearm_timer "$AUTO_REARM_INTERVAL"

    systemctl daemon-reload

    if [[ "$AUTO_REARM" == "yes" ]]; then
        systemctl enable rearm.timer >/dev/null 2>&1 || true

        if systemctl is-active --quiet rearm.timer 2>/dev/null; then
            systemctl restart rearm.timer
        else
            systemctl start rearm.timer
        fi
    else
        systemctl disable --now rearm.timer 2>/dev/null || true
    fi

    return 0
}

###############################################################################
# Enable Automatic Rearm
###############################################################################

enable_auto_rearm() {

    set_config_value AUTO_REARM yes
    load_defaults

    apply_rearm_timer || return 1

    success "Automatic Rearm enabled (${AUTO_REARM_INTERVAL})."

}

###############################################################################
# Disable Automatic Rearm
###############################################################################

disable_auto_rearm() {

    set_config_value AUTO_REARM no
    load_defaults

    systemctl disable --now rearm.timer 2>/dev/null || true

    success "Automatic Rearm disabled."

}

###############################################################################
# Manual Rearm
###############################################################################

manual_rearm() {

    clear

    echo "Running Rearm..."
    echo

    bash "$BASE_DIR/rearm.sh"

    echo
    echo "Done."

    read -rp "Press Enter..."

}

###############################################################################
# Main Rearm Menu
###############################################################################

rearm_menu() {

    while true; do
        load_defaults
        clear

        echo "=================================================="
        echo "                  Rearm DNS"
        echo "=================================================="
        echo
        echo "1) Manual Rearm"
        echo
        echo "2) Automatic Rearm"
        echo
        echo "0) Back"
        echo
        read -rp "Select: " choice

        case "$choice" in
            1) manual_rearm ;;
            2) menu_auto_rearm ;;
            0) return ;;
            *)
                echo
                echo "Invalid selection."
                sleep 1
                ;;
        esac
    done

}

###############################################################################
# Automatic Rearm Menu
###############################################################################

menu_auto_rearm() {

    while true; do
        load_defaults
        clear

        echo "=================================================="
        echo "              Automatic Rearm"
        echo "=================================================="
        echo
        echo "Status   : $AUTO_REARM"
        echo "Interval : $AUTO_REARM_INTERVAL"
        echo
        echo "1) Enable"
        echo
        echo "2) Disable"
        echo
        echo "3) Set Interval"
        echo
        echo "4) Run Now"
        echo
        echo "0) Back"
        echo
        read -rp "Select: " choice

        case "$choice" in
            1) enable_auto_rearm ;;
            2) disable_auto_rearm ;;
            3) menu_rearm_interval ;;
            4) manual_rearm ;;
            0) return ;;
            *)
                echo
                echo "Invalid selection."
                sleep 1
                ;;
        esac
    done

}

###############################################################################
# Rearm Interval Menu
###############################################################################

menu_rearm_interval() {

    load_defaults

    clear

    echo "=================================================="
    echo "               Rearm Interval"
    echo "=================================================="
    echo
    echo "Current : $AUTO_REARM_INTERVAL"
    echo
    echo "1) 30m"
    echo "2) 1h"
    echo "3) 2h"
    echo "4) 4h"
    echo "5) 6h"
    echo "6) 12h"
    echo "7) 24h"
    echo
    echo "0) Cancel"
    echo
    read -rp "Select: " choice

    local interval=""

    case "$choice" in
        1) interval=30m ;;
        2) interval=1h ;;
        3) interval=2h ;;
        4) interval=4h ;;
        5) interval=6h ;;
        6) interval=12h ;;
        7) interval=24h ;;
        *) return 0 ;;
    esac

    if ! validate_rearm_interval "$interval"; then
        warning "Invalid Rearm interval: $interval"
        read -rp "Press Enter..."
        return 1
    fi

    set_config_value AUTO_REARM_INTERVAL "$interval"

    if ! apply_rearm_timer; then
        warning "Failed to apply Rearm interval."
        read -rp "Press Enter..."
        return 1
    fi

    success "Rearm interval set to ${interval}."
    echo
    systemctl list-timers --no-pager rearm.timer 2>/dev/null || true
    read -rp "Press Enter..."

}

###############################################################################
# Configuration Writer
###############################################################################

set_config_value() {

    local key="$1"
    local value="$2"
    local file="$CONFIG_DIR/defaults.conf"
    local escaped_value

    [[ -f "$file" ]] || fatal "Configuration file not found: $file"

    escaped_value="${value//\\/\\\\}"
    escaped_value="${escaped_value//&/\\&}"
    escaped_value="${escaped_value//|/\\|}"

    if grep -qE "^${key}=" "$file"; then
        sed -Ei "s|^(${key}=).*|\1\"${escaped_value}\"|" "$file"
    else
        printf '%s="%s"\n' "$key" "$value" >> "$file"
    fi

}

###############################################################################
# Load Rearm Configuration
###############################################################################

load_defaults() {

    AUTO_REARM="$(config_get AUTO_REARM 2>/dev/null || true)"
    AUTO_REARM_INTERVAL="$(config_get AUTO_REARM_INTERVAL 2>/dev/null || true)"

    : "${AUTO_REARM:=no}"
    : "${AUTO_REARM_INTERVAL:=1h}"

}
