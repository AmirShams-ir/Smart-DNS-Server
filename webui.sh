#!/usr/bin/env bash
# ==============================================================================
#
# Smart DNS Server - Update Script
#
# https://github.com/AmirShams-ir/Smart-DNS-Server
#
# Copyright (c) 2026 Amir Shams
# Licensed under Apache-2.0
#
# ==============================================================================

set -Eeuo pipefail


###############################################################################
# Base Directory
###############################################################################

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

###############################################################################
# Configs
###############################################################################

source "${BASE_DIR}/config/blocklists.conf"
source "${BASE_DIR}/config/defaults.conf"

###############################################################################
# Common Library
###############################################################################

source "${BASE_DIR}/lib/common.sh"
source "${BASE_DIR}/lib/dns.sh"
source "${BASE_DIR}/lib/race.sh"
source "${BASE_DIR}/lib/system.sh"
source "${BASE_DIR}/lib/unbound.sh"
source "${BASE_DIR}/lib/blocklists.sh"

source "${BASE_DIR}/lib/ui.sh"
source "${BASE_DIR}/lib/stats.sh"
source "${BASE_DIR}/lib/dns-monitor.sh"
source "${BASE_DIR}/lib/block-manager.sh"
source "${BASE_DIR}/lib/config-manager.sh"
source "${BASE_DIR}/lib/rearm-manager.sh"
source "${BASE_DIR}/lib/security-manager.sh"

trap -p