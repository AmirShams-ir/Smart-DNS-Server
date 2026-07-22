#!/usr/bin/env bash

###############################################################################
# Block Manager
###############################################################################

BLOCK_DIR="$BASE_DIR/blocklists"

###############################################################################
# Main Menu
###############################################################################

block_menu() {

    while true
    do
        clear

        echo "=================================================="
        echo "                Block Manager"
        echo "=================================================="
        echo

        mapfile -t categories < <(
            find "$BLOCK_DIR" \
                -mindepth 1 \
                -maxdepth 1 \
                -type d |
            sort
        )

        for i in "${!categories[@]}"
        do
            printf "%d) %s\n" \
                "$((i+1))" \
                "$(basename "${categories[$i]}")"
        done

        echo
        echo "0) Back"
        echo

        read -rp "Select: " choice

        case "$choice" in

            0)
                return
                ;;

            *)

                if [[ "$choice" =~ ^[0-9]+$ ]] &&
                   (( choice>=1 && choice<=${#categories[@]} ))
                then
                    menu_block_files \
                        "${categories[$((choice-1))]}"
                fi
                ;;

        esac

    done

}

###############################################################################
# Category Menu
###############################################################################

menu_block_files() {

    local category="$1"

    while true
    do

        clear

        echo "=================================================="
        echo "Category : $(basename "$category")"
        echo "=================================================="
        echo

        mapfile -t files < <(
            find "$category" \
                -maxdepth 1 \
                -type f \
                -name "*.txt" |
            sort
        )

        for i in "${!files[@]}"
        do
            printf "%d) %s\n" \
                "$((i+1))" \
                "$(basename "${files[$i]}")"
        done

        echo
        echo "A) Add File"
        echo "D) Delete File"
        echo
        echo "0) Back"
        echo

        read -rp "Select: " choice

        case "${choice^^}" in

            0)
                return
                ;;

            A)
                add_block_file "$category"
                ;;

            D)
                delete_block_file "$category"
                ;;

            *)

                if [[ "$choice" =~ ^[0-9]+$ ]] &&
                   (( choice>=1 && choice<=${#files[@]} ))
                then
                    menu_edit_file \
                        "${files[$((choice-1))]}"
                else

                    echo
                    echo "Invalid selection."
                    pause

                fi
                ;;

        esac

    done

}

###############################################################################
# Add File
###############################################################################

add_block_file() {

    local category="$1"

    clear

    echo "=================================================="
    echo "                  Add File"
    echo "=================================================="
    echo

    read -rp "File name : " filename

    [[ -z "$filename" ]] && return

    filename="${filename%.txt}.txt"

    local file="$category/$filename"

    if [[ -e "$file" ]]
    then
        echo
        echo "File already exists."
        pause
        return
    fi

    touch "$file"

    echo
    echo "File created."
    echo

    "${EDITOR:-nano}" "$file"

}

###############################################################################
# Delete File
###############################################################################

delete_block_file() {

    local category="$1"

    clear

    echo "=================================================="
    echo "                Delete File"
    echo "=================================================="
    echo

    mapfile -t files < <(
        find "$category" \
            -maxdepth 1 \
            -type f \
            -name "*.txt" |
        sort
    )

    if ((${#files[@]} == 0))
    then
        echo "No files found."
        pause
        return
    fi

    for i in "${!files[@]}"
    do
        printf "%2d) %s\n" \
            "$((i+1))" \
            "$(basename "${files[$i]}")"
    done

    echo
    echo "0) Cancel"
    echo

    read -rp "Select: " choice

    [[ "$choice" == 0 ]] && return

    if ! [[ "$choice" =~ ^[0-9]+$ ]] ||
       (( choice < 1 || choice > ${#files[@]} ))
    then
        echo
        echo "Invalid selection."
        pause
        return
    fi

    local file="${files[$((choice-1))]}"

    echo
    read -rp "Delete $(basename "$file") ? [y/N] " ans

    [[ "$ans" =~ ^[Yy]$ ]] || return

    rm -f "$file"

    echo
    echo "Deleted successfully."

    pause

}

###############################################################################
# File Menu
###############################################################################

menu_edit_file() {

    local file="$1"

    while true
    do

        clear

        echo "=================================================="
        echo "File : $(basename "$file")"
        echo "=================================================="
        echo

        echo "1) Edit with nano"
        echo "2) Edit with vim"
        echo "3) View file"
        echo "4) Reload DNS"
        echo "5) Rename File"
        echo "6) Delete File"
        echo
        echo "0) Back"
        echo

        read -rp "Select: " choice

        case "$choice" in

            1)
                "${EDITOR:-nano}" "$file"
                ;;

            2)
                vim "$file"
                ;;

            3)

                clear

                echo "=================================================="
                echo "File : $(basename "$file")"
                echo "=================================================="
                echo

                cat "$file"

                echo
                pause

                ;;

            4)

                clear

                echo
                echo "Reloading DNS..."
                echo

                bash "$BASE_DIR/rearm.sh"

                pause

                ;;

            5)

                rename_block_file "$file"

                return

                ;;

            6)

                echo

                read -rp "Delete $(basename "$file") ? [y/N] " ans

                [[ "$ans" =~ ^[Yy]$ ]] || continue

                rm -f "$file"

                echo
                echo "Deleted."

                pause

                return

                ;;

            0)
                return
                ;;

            *)

                echo
                echo "Invalid selection."

                pause

                ;;

        esac

    done

}

###############################################################################
# Rename File
###############################################################################

rename_block_file() {

    local file="$1"

    clear

    echo "=================================================="
    echo "                Rename File"
    echo "=================================================="
    echo

    echo "Current : $(basename "$file")"
    echo

    read -rp "New name : " newname

    [[ -z "$newname" ]] && return

    newname="${newname%.txt}.txt"

    local newfile
    newfile="$(dirname "$file")/$newname"

    if [[ -e "$newfile" ]]
    then
        echo
        echo "File already exists."
        pause
        return
    fi

    mv "$file" "$newfile"

    echo
    echo "Renamed successfully."

    pause

}

###############################################################################
# Reload DNS
###############################################################################

reload_dns() {

    clear

    echo "=================================================="
    echo "                 Reload DNS"
    echo "=================================================="
    echo

    if [[ -x "$BASE_DIR/rearm.sh" ]]
    then
        bash "$BASE_DIR/rearm.sh"
    else
        systemctl reload unbound
    fi

    echo
    echo "Done."

    pause

}