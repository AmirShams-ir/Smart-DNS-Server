#!/usr/bin/env bash

###############################################################################
# Security Manager
###############################################################################

security_menu() {

    while true
    do

        clear

        echo "=================================================="
        echo "               Security Manager"
        echo "=================================================="
        echo

        echo "1) DNSSEC Manager"
        echo
        echo "2) DNS over TLS (DoT)"
        echo
        echo "3) Access Control (ACL)"
        echo
        echo "4) Rate Limiting"
        echo
        echo "0) Back"
        echo

        read -rp "Select: " choice

        case "$choice" in

            1)

                dnssec_menu

                ;;

            2)

                dot_menu

                ;;

            3)

                acl_menu

                ;;

            4)

                ratelimit_menu

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

dnssec_menu() {

    while true
    do

        clear

        echo "=================================================="
        echo "                DNSSEC Manager"
        echo "=================================================="
        echo

        echo "1) Enable DNSSEC"
        echo
        echo "2) Disable DNSSEC"
        echo
        echo "3) Status"
        echo
        echo "4) Update Root Trust Anchor"
        echo
        echo "0) Back"
        echo

        read -rp "Select: " choice

        case "$choice" in

            1) enable_dnssec ;;

            2) disable_dnssec ;;

            3) dnssec_status ;;

            4) update_root_key ;;

            0) return ;;

        esac

    done

}

dot_menu() {

    while true
    do

        clear

        echo "=================================================="
        echo "               DNS over TLS"
        echo "=================================================="
        echo

        echo "1) Get Certificate"
        echo
        echo "2) Activate DoT"
        echo
        echo "3) Deactivate DoT"
        echo
        echo "4) Status"
        echo
        echo "0) Back"
        echo

        read -rp "Select: " choice

        case "$choice" in

            1) dot_get_certificate ;;

            2) dot_enable ;;

            3) dot_disable ;;

            4) dot_status ;;

            0) return ;;

        esac

    done

}

acl_menu() {

    while true
    do

        clear

        echo "=================================================="
        echo "                 ACL Manager"
        echo "=================================================="
        echo

        echo "1) Enable ACL"
        echo
        echo "2) Disable ACL"
        echo
        echo "3) Add Network"
        echo
        echo "4) Remove Network"
        echo
        echo "5) Show Rules"
        echo
        echo "6) Reset Default"
        echo
        echo "0) Back"
        echo

        read -rp "Select: " choice

        case "$choice" in

            1) acl_enable ;;

            2) acl_disable ;;

            3) acl_add ;;

            4) acl_remove ;;

            5) acl_show ;;

            6) acl_reset ;;

            0) return ;;

        esac

    done

}

ratelimit_menu() {

    while true
    do

        clear

        echo "=================================================="
        echo "             Rate Limiting"
        echo "=================================================="
        echo

        echo "1) Enable"
        echo
        echo "2) Disable"
        echo
        echo "3) Edit Limit"
        echo
        echo "4) Status"
        echo
        echo "0) Back"
        echo

        read -rp "Select: " choice

        case "$choice" in

            1) ratelimit_enable ;;

            2) ratelimit_disable ;;

            3) ratelimit_edit ;;

            4) ratelimit_status ;;

            0) return ;;

        esac

    done

}

