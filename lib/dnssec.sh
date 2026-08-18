#!/usr/bin/env bash

###############################################################################
#
# DNSSEC Library
#
###############################################################################

DNSSEC_CONF="/etc/unbound/unbound.conf.d/dnssec.conf"

###############################################################################
# Enable DNSSEC
###############################################################################


enable_dnssec() {

rm -f /etc/unbound/unbound.conf.d/root-auto-trust-anchor-file.conf

    cat > "$DNSSEC_CONF" <<EOF
server:

    auto-trust-anchor-file: "/var/lib/unbound/root.key"

    harden-dnssec-stripped: yes

    harden-algo-downgrade: yes

    val-clean-additional: yes

EOF

    if ! unbound-checkconf
    then
        echo
        echo "Invalid configuration."
        echo
        pause
        return 1
    fi

    systemctl restart unbound

    echo
    echo "DNSSEC Enabled."

    pause

}

###############################################################################
# Disable DNSSEC
###############################################################################

disable_dnssec() {

    rm -f "$DNSSEC_CONF"

    unbound-checkconf >/dev/null 2>&1

    systemctl restart unbound

    echo
    echo "DNSSEC Disabled."

    pause

}

###############################################################################
# Status
###############################################################################

dnssec_status() {

    clear

    echo "=================================================="
    echo "                 DNSSEC Status"
    echo "=================================================="
    echo

    if [[ -f "$DNSSEC_CONF" ]]
    then
        echo "Status : Enabled"
    else
        echo "Status : Disabled"
    fi

    echo

    if [[ -f /var/lib/unbound/root.key ]]
    then

        echo "Root Trust Anchor"

        unbound-anchor -l

    else

        echo "Root Trust Anchor : Missing"

    fi

    echo

    pause

}

###############################################################################
# Update Root Trust Anchor
###############################################################################

update_root_key() {

    clear

    echo "Updating Root Trust Anchor..."
    echo

    unbound-anchor \
        -a /var/lib/unbound/root.key

    if [[ $? -eq 0 ]]
    then

        systemctl restart unbound

        echo
        echo "Root Trust Anchor updated."

    else

        echo
        echo "Update failed."

    fi

    echo

    pause

}