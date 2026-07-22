#!/usr/bin/env bash

config_menu() {

    while true; do

        clear

        echo "=================================================="
        echo "                Config Manager"
        echo "=================================================="
        echo
        echo "1) Edit defaults.conf"
        echo
        echo "2) Edit blocklists.conf"
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