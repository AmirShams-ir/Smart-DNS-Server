#!/usr/bin/env bash

###############################################################################
#
# Access Control (ACL)
#
###############################################################################

ACL_CONF="/etc/unbound/unbound.conf.d/acl.conf"

acl_enable() {

    cat > "$ACL_CONF" <<EOF
server:

    access-control: 127.0.0.0/8 allow
    access-control: ::1 allow

    access-control: 192.168.1.0/24 allow
    access-control: 10.0.0.0/8 allow
    access-control: 172.16.0.0/12 allow

EOF

    if ! unbound-checkconf >/dev/null 2>&1
    then
        echo
        echo "Invalid configuration."
        pause
        return
    fi

    systemctl restart unbound

    echo
    echo "ACL Enabled."

    pause

}

acl_disable() {

    rm -f "$ACL_CONF"

    unbound-checkconf >/dev/null 2>&1

    systemctl restart unbound

    echo
    echo "ACL Disabled."

    pause

}

acl_add() {

    clear

    echo "=================================================="
    echo "                Add Network"
    echo "=================================================="
    echo

    read -rp "CIDR : " NETWORK

    [[ -z "$NETWORK" ]] && return

    echo

    echo "1) Allow"
    echo "2) Deny"
    echo "3) Refuse"
    echo

    read -rp "Select : " MODE

    case "$MODE" in

        1) ACTION="allow" ;;
        2) ACTION="deny" ;;
        3) ACTION="refuse" ;;
        *) return ;;

    esac

    echo "    access-control: $NETWORK $ACTION" >> "$ACL_CONF"

    if ! unbound-checkconf >/dev/null 2>&1
    then

        sed -i '$d' "$ACL_CONF"

        echo
        echo "Invalid Network."

        pause

        return

    fi

    systemctl restart unbound

    echo
    echo "Rule Added."

    pause

}

acl_remove() {

    clear

    echo "=================================================="
    echo "             Remove Network"
    echo "=================================================="
    echo

    grep "access-control:" "$ACL_CONF" |
    nl

    echo

    read -rp "Number : " NUM

    [[ -z "$NUM" ]] && return

    sed -i "${NUM}d" "$ACL_CONF"

    systemctl restart unbound

    echo
    echo "Rule Removed."

    pause

}

acl_reset() {

    rm -f "$ACL_CONF"

    acl_enable

}

###############################################################################
# Detect Local Networks
###############################################################################

acl_detect() {

    clear

    echo "=================================================="
    echo "           Detect Local Networks"
    echo "=================================================="
    echo

    [[ -f "$ACL_CONF" ]] || acl_enable >/dev/null 2>&1

    local COUNT=0
    local NETWORK

    ###########################################################
    # IPv4 Networks
    ###########################################################

    while read -r NETWORK
    do

        [[ -z "$NETWORK" ]] && continue

        grep -qF "access-control: $NETWORK allow" "$ACL_CONF" && continue

        echo "    access-control: $NETWORK allow" >> "$ACL_CONF"

        echo "Added IPv4 : $NETWORK"

        ((COUNT++))

    done < <(

        ip -o route |

        awk '
            $1 ~ /^[0-9]/ &&
            $1 != "default" {
                print $1
            }
        ' |

        sort -u

    )

    ###########################################################
    # IPv6 Networks
    ###########################################################

    while read -r NETWORK
    do

        [[ -z "$NETWORK" ]] && continue

        grep -qF "access-control: $NETWORK allow" "$ACL_CONF" && continue

        echo "    access-control: $NETWORK allow" >> "$ACL_CONF"

        echo "Added IPv6 : $NETWORK"

        ((COUNT++))

    done < <(

        ip -o -6 route |

        awk '
            $1 ~ /:/ &&
            $1 != "default" &&
            $1 != "::1/128" {
                print $1
            }
        ' |

        sort -u

    )

    ###########################################################
    # Validate
    ###########################################################

    if ! unbound-checkconf >/dev/null 2>&1
    then

        echo
        echo "Configuration Error."

        pause

        return

    fi

    systemctl restart unbound

    echo
    echo "$COUNT network(s) added."

    pause

}