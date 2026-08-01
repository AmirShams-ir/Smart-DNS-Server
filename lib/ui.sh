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

4) Security Manager

5) Rearm Manager

6) Statistics

7) Install WebUI

8) Update Script

9) Uninstall Script

0) Exit Script

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

                security_menu

                ;;

            5)

                rearm_menu

                ;;

            6)

                stats_menu

                ;;

            7)

                bash webui.sh

                ;;

            8)

                bash update.sh

                ;;            
                
            9)

                bash uninstall.sh

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
