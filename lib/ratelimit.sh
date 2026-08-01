#!/usr/bin/env bash

###############################################################################
#
# Rate Limiting
#
###############################################################################

RATELIMIT_CONF="/etc/unbound/unbound.conf.d/ratelimit.conf"

DEFAULT_LIMIT=1000

###############################################################################
# Enable
###############################################################################

ratelimit_enable() {

    if [[ -f "$RATELIMIT_CONF" ]]
    then
        echo
        echo "Already Enabled."
        pause
        return
    fi

    cat > "$RATELIMIT_CONF" <<EOF
server:

    ratelimit: ${DEFAULT_LIMIT}

EOF

    if ! unbound-checkconf >/dev/null 2>&1
    then

        rm -f "$RATELIMIT_CONF"

        echo
        echo "Configuration Error."

        pause

        return

    fi

    systemctl restart unbound

    echo
    echo "Rate Limiting Enabled."

    pause

}

###############################################################################
# Disable
###############################################################################

ratelimit_disable() {

    rm -f "$RATELIMIT_CONF"

    unbound-checkconf >/dev/null 2>&1

    systemctl restart unbound

    echo
    echo "Rate Limiting Disabled."

    pause

}

###############################################################################
# Edit Limit
###############################################################################

ratelimit_edit() {

    clear

    echo "=================================================="
    echo "              Edit Rate Limit"
    echo "=================================================="
    echo

    CURRENT=$(
        grep "ratelimit:" "$RATELIMIT_CONF" 2>/dev/null |
        awk '{print $2}'
    )

    [[ -z "$CURRENT" ]] && CURRENT=$DEFAULT_LIMIT

    echo "Current : $CURRENT"
    echo

    read -rp "New Value : " VALUE

    [[ -z "$VALUE" ]] && return

    [[ "$VALUE" =~ ^[0-9]+$ ]] || {

        echo
        echo "Invalid Number."

        pause

        return

    }

    cat > "$RATELIMIT_CONF" <<EOF
server:

    ratelimit: $VALUE

EOF

    if ! unbound-checkconf >/dev/null 2>&1
    then

        echo
        echo "Configuration Error."

        pause

        return

    fi

    systemctl restart unbound

    echo
    echo "Rate Limit Updated."

    pause

}

###############################################################################
# Status
###############################################################################

ratelimit_status() {

    clear

    echo "=================================================="
    echo "             Rate Limiting"
    echo "=================================================="
    echo

    if [[ ! -f "$RATELIMIT_CONF" ]]
    then

        echo "Status : Disabled"

        echo

        pause

        return

    fi

    VALUE=$(
        grep "ratelimit:" "$RATELIMIT_CONF" |
        awk '{print $2}'
    )

    echo "Status : Enabled"

    echo

    echo "Limit  : $VALUE"

    echo

    if systemctl is-active --quiet unbound
    then

        echo "Service : Running"

    else

        echo "Service : Stopped"

    fi

    echo

    pause

}