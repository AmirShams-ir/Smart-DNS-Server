#!/usr/bin/env bash

###############################################################################
#
# DNS over TLS (DoT)
#
###############################################################################

DOT_CONF="/etc/unbound/unbound.conf.d/dot.conf"

###############################################################################
# Enable DoT
###############################################################################

dot_enable() {

    clear

    echo "=================================================="
    echo "                Enable DoT"
    echo "=================================================="
    echo

    read -rp "Certificate Domain : " DOMAIN

    [[ -z "$DOMAIN" ]] && return

    CERT_DIR="/etc/letsencrypt/live/$DOMAIN"

    if [[ ! -d "$CERT_DIR" ]]
    then
        echo
        echo "Certificate not found."
        pause
        return
    fi

    cat > "$DOT_CONF" <<EOF
server:

    interface: 0.0.0.0@853
    interface: ::0@853

    tls-port: 853

    tls-service-key: "$CERT_DIR/privkey.pem"

    tls-service-pem: "$CERT_DIR/fullchain.pem"

EOF

    if ! unbound-checkconf >/dev/null 2>&1
    then
        echo
        echo "Configuration Error."

        rm -f "$DOT_CONF"

        pause

        return
    fi

    systemctl restart unbound

    echo
    echo "DNS over TLS Enabled."

    pause

}

dot_disable() {

    clear

    echo "Disabling DoT..."
    echo

    rm -f "$DOT_CONF"

    unbound-checkconf >/dev/null 2>&1

    systemctl restart unbound

    echo
    echo "DNS over TLS Disabled."

    pause

}

dot_status() {

    clear

    echo "=================================================="
    echo "               DoT Status"
    echo "=================================================="
    echo

    if [[ -f "$DOT_CONF" ]]
    then

        echo "Status : Enabled"

    else

        echo "Status : Disabled"

    fi

    echo

    if ss -lnt | grep -q ':853'
    then

        echo "Port   : Listening"

    else

        echo "Port   : Closed"

    fi

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