#!/usr/bin/env bash

set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "$0")" && pwd)"
LIB_DIR="$PROJECT_ROOT/lib"

source "$LIB_DIR/common.sh"

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