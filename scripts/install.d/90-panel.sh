#!/usr/bin/env bash

set -euo pipefail

info "Installing Smart DNS Panel"

chmod +x     "$BASE_DIR/panel.sh"     "$BASE_DIR/webui.sh"     "$BASE_DIR/update.sh"     "$BASE_DIR/uninstall.sh"

success "Smart DNS Panel installed."
