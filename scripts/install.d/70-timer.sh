#!/usr/bin/env bash

set -euo pipefail

info "Installing systemd timers"

install -d -m755 /etc/systemd/system/rearm.timer.d

# Generate the service with the actual project path instead of a hard-coded path.
cat > /etc/systemd/system/rearm.service <<EOF
[Unit]
Description=Smart DNS Rearm
After=network-online.target
Wants=network-online.target

[Service]
Type=oneshot
ExecStart=/bin/bash ${BASE_DIR}/rearm.sh
EOF

install -m644     "$BASE_DIR/systemd/rearm.timer"     /etc/systemd/system/rearm.timer

install -m644     "$BASE_DIR/systemd/rearm-boot.timer"     /etc/systemd/system/rearm-boot.timer

# Synchronize the configured interval with systemd before the timer is enabled.
apply_rearm_timer

systemctl daemon-reload

if command -v systemd-analyze >/dev/null 2>&1; then
    systemd-analyze verify         /etc/systemd/system/rearm.service         /etc/systemd/system/rearm.timer         /etc/systemd/system/rearm-boot.timer
fi

chmod +x "$BASE_DIR/rearm.sh"

success "systemd timers installed (${AUTO_REARM_INTERVAL})."
