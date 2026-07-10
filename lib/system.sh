#!/usr/bin/env bash
# ==============================================================================
#
# Smart DNS Server - System Script
#
# https://github.com/AmirShams-ir/Smart-DNS-Server
#
# Copyright (c) 2026 Amir Shams
# Licensed under Apache-2.0
#
# ==============================================================================

require_root(){

    [[ $EUID -eq 0 ]] || fatal "Please run as root."

}

command_exists(){

    command -v "$1" >/dev/null 2>&1

}

restart_unbound(){

    systemctl restart unbound

}

reload_unbound(){

    systemctl reload unbound

}

check_unbound(){

    unbound-checkconf

}