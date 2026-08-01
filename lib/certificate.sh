#!/usr/bin/env bash

###############################################################################
#
# Certificate Manager
#
###############################################################################

LETSENCRYPT="/etc/letsencrypt/live"

###############################################################################
# Get Certificate
###############################################################################

get_certificate() {

    clear

    echo "=================================================="
    echo "              Get Certificate"
    echo "=================================================="
    echo

    read -rp "Domain : " DOMAIN

    [[ -z "$DOMAIN" ]] && return

    read -rp "Email  : " EMAIL

    [[ -z "$EMAIL" ]] && return

    echo
    echo "Requesting Certificate..."
    echo

    certbot certonly \
        --standalone \
        --agree-tos \
        --non-interactive \
        --email "$EMAIL" \
        -d "$DOMAIN"

    if [[ $? -ne 0 ]]
    then

        echo
        echo "Certificate request failed."

        pause

        return

    fi

    echo
    echo "Certificate installed successfully."

    pause

}

renew_certificate() {

    clear

    echo "=================================================="
    echo "            Renew Certificate"
    echo "=================================================="
    echo

    certbot renew

    if [[ $? -eq 0 ]]
    then

        echo
        echo "Certificate renewed."

    else

        echo
        echo "Renew failed."

    fi

    pause

}

certificate_status() {

    clear

    echo "=================================================="
    echo "           Certificate Status"
    echo "=================================================="
    echo

    if [[ ! -d "$LETSENCRYPT" ]]
    then

        echo "No certificates installed."

        pause

        return

    fi

    for CERT in "$LETSENCRYPT"/*
    do

        [[ -d "$CERT" ]] || continue

        DOMAIN=$(basename "$CERT")

        CERTFILE="$CERT/fullchain.pem"

        echo "Domain : $DOMAIN"

        openssl x509 \
            -in "$CERTFILE" \
            -noout \
            -dates

        echo

    done

    pause

}

delete_certificate() {

    clear

    echo "=================================================="
    echo "            Delete Certificate"
    echo "=================================================="
    echo

    read -rp "Domain : " DOMAIN

    [[ -z "$DOMAIN" ]] && return

    certbot delete \
        --cert-name "$DOMAIN"

    pause

}