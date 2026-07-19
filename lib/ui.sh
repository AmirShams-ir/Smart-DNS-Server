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
                monitor_menu || :
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
                echo "Invalid selection."
                read -rp "Press Enter..."

            ;;

        esac

    done

}
