#!/usr/bin/env bash

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

            1)
                manual_rearm
                ;;

            2)
                menu_auto_rearm
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

manual_rearm() {

    clear

    echo "Running Rearm..."

    echo

    bash "$BASE_DIR/rearm.sh"

    echo
    echo "Done."

    read -rp "Press Enter..."

}

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

            1)
                systemctl enable --now rearm.timer
                ;;

            2)
                systemctl disable --now rearm.timer
                ;;

            3)
                menu_rearm_interval
                ;;

            4)
                manual_rearm
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

menu_rearm_interval() {

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

    case "$choice" in

        1) set_config_value AUTO_REARM_INTERVAL 30m ;;
        2) set_config_value AUTO_REARM_INTERVAL 1h ;;
        3) set_config_value AUTO_REARM_INTERVAL 2h ;;
        4) set_config_value AUTO_REARM_INTERVAL 4h ;;
        5) set_config_value AUTO_REARM_INTERVAL 6h ;;
        6) set_config_value AUTO_REARM_INTERVAL 12h ;;
        7) set_config_value AUTO_REARM_INTERVAL 24h ;;

        *) ;;

    esac

}

