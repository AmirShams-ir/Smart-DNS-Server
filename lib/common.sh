#!/usr/bin/env bash
# ==============================================================================
#
# Smart DNS Server - Common Script
#
# https://github.com/AmirShams-ir/Smart-DNS-Server
#
# Copyright (c) 2026 Amir Shams
# Licensed under Apache-2.0
#
# ==============================================================================

set -Eeuo pipefail


###############################################################################
# Project
###############################################################################

VERSION="1.0.0-beta1"

PROJECT="Smart DNS Server"

LOG_DIR="/var/log/smartdns"

LOG_FILE="${LOG_DIR}/install.log"

UNBOUND_DIR="/etc/unbound"

SUPPORTED_OS=("debian" "ubuntu")

###############################################################################
# Directories
###############################################################################

readonly BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

readonly SYSTEM_CONFIG_DIR="/etc/smartdns"

# Project configuration directory.
readonly CONFIG_DIR="${BASE_DIR}/config"

readonly SCRIPT_DIR="${BASE_DIR}/scripts"

readonly INSTALL_DIR="${SCRIPT_DIR}/install.d"

readonly LOG_DIR="/var/log/smartdns"

readonly LOG_FILE="${LOG_DIR}/install.log"

###############################################################################
# Colors
###############################################################################

RED='\033[31m'
GREEN='\033[32m'
YELLOW='\033[33m'
BLUE='\033[34m'
MAGENTA='\033[35m'
CYAN='\033[36m'
WHITE='\033[37m'
BOLD='\033[1m'
RESET='\033[0m'

###############################################################################
# Logging
###############################################################################

info() {

    printf "${BLUE}[*] %s${RESET}\n" "$1"

}

success() {

    printf "${GREEN}[✓] %s${RESET}\n" "$1"

}

warning() {

    printf "${YELLOW}[!] %s${RESET}\n" "$1"

}

fatal() {

    printf "${RED}[✗] %s${RESET}\n" "$1"

    exit 1

}

###############################################################################
# Banner
###############################################################################

banner() {

cat <<EOF

==============================================================

                 Smart DNS Server

                 Version ${VERSION}

==============================================================

Repository

https://github.com/AmirShams-ir/Smart-DNS-Server

==============================================================

EOF

}

###############################################################################
# Root
###############################################################################

require_root() {

    [[ "$EUID" -eq 0 ]] || fatal "Please run as root."

}

###############################################################################
# OS
###############################################################################

require_os() {

    [[ -f /etc/os-release ]] || fatal "Cannot detect operating system."

    source /etc/os-release

    case "$ID" in

        debian|ubuntu)

            success "$PRETTY_NAME"

        ;;

        *)

            fatal "Unsupported operating system."

        ;;

    esac

}

###############################################################################
# Logging
###############################################################################

start_log() {

    mkdir -p "$LOG_DIR"

    touch "$LOG_FILE"

    exec > >(tee -a "$LOG_FILE")

    exec 2>&1

}

###############################################################################
# Run Script
###############################################################################

run_script() {

    local script="$1"

    [[ -f "$script" ]] || fatal "Missing $(basename "$script")"

    info "Executing $(basename "$script")"

    source "$script"

}

###############################################################################
# Set Config
###############################################################################

config_get() {

    local KEY="$1"
    local FILE="${CONFIG_DIR}/defaults.conf"

    [[ -f "$FILE" ]] || return 1

    awk -F= -v key="$KEY" '
        $1 == key {
            value=$0
            sub(/^[^=]*=/, "", value)
            gsub(/^[[:space:]]+|[[:space:]]+$/, "", value)
            if (value ~ /^".*"$/) {
                sub(/^"/, "", value)
                sub(/"$/, "", value)
            }
            print value
            exit
        }
    ' "$FILE"

}