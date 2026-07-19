#!/usr/bin/env bash

BLOCK_DIR="$BASE_DIR/blocklists"

block_menu() {

    while true; do
        clear

        echo "=================================================="
        echo "                Block Manager"
        echo "=================================================="
        echo

        mapfile -t categories < <(
            find "$BLOCK_DIR" -mindepth 1 -maxdepth 1 -type d | sort
        )

        for i in "${!categories[@]}"; do
            printf "%2d) %s\n" \
                "$((i+1))" \
                "$(basename "${categories[$i]}")"
        done

        echo
        echo " 0) Back"
        echo

        read -rp "Select: " choice

        [[ "$choice" == 0 ]] && return

        if [[ "$choice" =~ ^[0-9]+$ ]] &&
           (( choice>=1 && choice<=${#categories[@]} ))
        then
            menu_block_files "${categories[$((choice-1))]}"
        fi

    done

}


menu_block_files() {

    local category="$1"

    while true; do

        clear

        echo "=================================================="
        echo "Category : $(basename "$category")"
        echo "=================================================="
        echo

        mapfile -t files < <(
            find "$category" -maxdepth 1 -type f | sort
        )

        for i in "${!files[@]}"; do
            printf "%2d) %s\n" \
                "$((i+1))" \
                "$(basename "${files[$i]}")"
        done

        echo
        echo " 0) Back"
        echo

        read -rp "Select: " choice

        [[ "$choice" == 0 ]] && return

        if [[ "$choice" =~ ^[0-9]+$ ]] &&
           (( choice>=1 && choice<=${#files[@]} ))
        then
            menu_edit_file "${files[$((choice-1))]}"
        fi

    done

}

menu_edit_file() {

    local file="$1"

    while true; do

        clear

        echo "=================================================="
        echo "File : $(basename "$file")"
        echo "=================================================="
        echo

        echo "1) Edit with nano"
        echo "2) Edit with vim"
        echo "3) View file"
        echo "4) Reload DNS"
        echo
        echo "0) Back"
        echo

        read -rp "Select: " choice

        case "$choice" in

            1)

                command -v nano >/dev/null || {
                echo
                echo "nano is not installed."
                read -rp "Press Enter..."
                continue
                } 

                nano "$file"

                ;;

            2)

                command -v vim >/dev/null || {
                echo
                echo "vim is not installed."
                read -rp "Press Enter..."
                continue
                }  

                vim "$file"

                ;;

            3)

                clear

                cat "$file"

                echo
                read -rp "Press Enter..."

                ;;

            4)

                "bash $BASE_DIR/rearm.sh"   

                ;;

            0)

                return

                ;;

            *)

                echo
                echo "Invalid selection."
                read -rp "Press Enter..."

            ;;

        esac

    done

}