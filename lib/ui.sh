#!/usr/bin/env bash

#
# Smart DNS Server
# UI Library
#

PANEL_TITLE="Smart DNS Control Panel"

###########################################################
# Banner
###########################################################

show_banner() {

    clear

    echo
    echo "=================================================="
    echo "               $PANEL_TITLE"
    echo "=================================================="
    echo

}

###########################################################
# Pause
###########################################################

pause() {

    echo
    read -rp "Press Enter to continue..."

}

###########################################################
# Not Implemented
###########################################################

coming_soon() {

    echo
    echo "Coming Soon..."
    pause

}

###########################################################
# Main Menu
###########################################################

main_menu() {

    while true; do

        show_banner

        cat <<EOF
1) Live DNS Monitor

2) Block Manager

3) Config Manager

4) Rearm DNS

5) Statistics

0) Exit

EOF

        read -rp "Select: " OPTION

        case "$OPTION" in

            1)
                live_dns_monitor
                ;;

            2)
                block_menu
                ;;

            3)
                config_menu
                ;;

            4)
                rearm_menu
                ;;

            5)
                stats_menu
                ;;

            0)
                clear
                exit 0
                ;;

            *)
                echo
                echo "Invalid option."
                sleep 1
                ;;

        esac

    done

}

###########################################################
# Menus
###########################################################

block_menu() {

    show_banner

    echo "Block Manager"
    echo

    coming_soon

}

config_menu() {

    while true; do

        show_banner

        cat <<EOF
Configuration

1) DNS Settings

2) Cache Settings

3) IPv6

4) DNSSEC

5) Logging

6) Upstream Settings

0) Back

EOF

        read -rp "Select: " OPTION

        case "$OPTION" in

            0)
                return
                ;;

            *)
                coming_soon
                ;;

        esac

    done

}

rearm_menu() {

    show_banner

    echo "Rearm DNS"
    echo

    coming_soon

}

stats_menu() {

    show_banner

    echo "Statistics"
    echo

    coming_soon

}