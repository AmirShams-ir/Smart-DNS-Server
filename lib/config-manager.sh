#!/usr/bin/env bash

CONFIG_DIR="$BASE_DIR/config"

config_menu() {

    while true; do

        clear

        echo "=================================================="
        echo "                Config Manager"
        echo "=================================================="
        echo
        echo "1) Edit Defaults"
        echo
        echo "2) Edit Block-lists"
        echo        
        echo "3) Edit Cache-Setting"
        echo
        echo "0) Back"
        echo
        read -rp "Select: " choice

        case "$choice" in

            1)
                edit_defaults
                ;;

            2)
                edit_blocklists
                ;;            
                
            3)
                edit_cache
                ;;

            0)
                return
                ;;

            *)
                echo
                echo "Invalid selection."
                sleep 1
                ;;
        esac

    done

}

edit_defaults() {

    local file="$CONFIG_DIR/defaults.conf"

    if [[ ! -f "$file" ]]; then
        echo
        echo "defaults.conf not found."
        read -rp "Press Enter..."
        return
    fi

    "${EDITOR:-nano}" "$file"

    echo
    echo "Saved successfully."
    read -rp "Press Enter..."

}

edit_blocklists() {

    local file="$CONFIG_DIR/blocklists.conf"

    if [[ ! -f "$file" ]]; then
        echo
        echo "blocklists.conf not found."
        read -rp "Press Enter..."
        return
    fi

    "${EDITOR:-nano}" "$file"

    echo
    echo "Saved successfully."
    read -rp "Press Enter..."

}

edit_cache() {

    local file="/etc/unbound/unbound.conf.d/cache.conf"

    if [[ ! -f "$file" ]]; then
        echo
        echo "cache.conf not found."
        read -rp "Press Enter..."
        return
    fi

    "${EDITOR:-nano}" "$file"

    echo
    echo "Saved successfully."
    read -rp "Press Enter..."

}