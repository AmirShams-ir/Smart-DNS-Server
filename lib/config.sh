#!/usr/bin/env bash
# ==============================================================================
#
# Smart DNS Server - Config Script
#
# https://github.com/AmirShams-ir/Smart-DNS-Server
#
# Copyright (c) 2026 Amir Shams
# Licensed under Apache-2.0
#
# ==============================================================================

PROJECT_CONFIG_DIR="${BASE_DIR}/config"

GLOBAL_UPSTREAMS="${PROJECT_CONFIG_DIR}/upstreams-global.conf"
LOCAL_UPSTREAMS="${PROJECT_CONFIG_DIR}/upstreams-local.conf"

BLOCKLIST_FILE="${PROJECT_CONFIG_DIR}/blocklists.conf"
DEFAULTS_FILE="${PROJECT_CONFIG_DIR}/defaults.conf"