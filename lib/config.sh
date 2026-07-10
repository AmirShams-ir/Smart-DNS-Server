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

GLOBAL_UPSTREAMS="$CONFIG_DIR/upstreams-global.conf"
LOCAL_UPSTREAMS="$CONFIG_DIR/upstreams-local.conf"

BLOCKLIST_FILE="$CONFIG_DIR/blocklists.conf"

DEFAULTS_FILE="$CONFIG_DIR/defaults.conf"