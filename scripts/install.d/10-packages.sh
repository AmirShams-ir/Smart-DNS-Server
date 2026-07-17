#!/usr/bin/env bash

set -euo pipefail

info  "Installing required packages"

apt-get update

apt-get install -y \
    unbound \
    unbound-anchor \
    dnsutils \
    curl \
    wget \
    tcpdump \
    tshark \
    ca-certificates

success "Packages installed"