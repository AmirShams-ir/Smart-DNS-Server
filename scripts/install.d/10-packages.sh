#!/usr/bin/env bash

set -euo pipefail

log_step "Installing required packages"

apt-get update

apt-get install -y \
    unbound \
    unbound-anchor \
    dnsutils \
    curl \
    wget \
    ca-certificates

log_ok "Packages installed"