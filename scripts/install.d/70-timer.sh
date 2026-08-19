#!/usr/bin/env bash

set -Eeuo pipefail

###############################################################################
# Smart DNS Server - systemd Rearm Timer Installation
###############################################################################

info "Installing systemd Rearm timer"

validate_rearm_interval "$AUTO_REARM_INTERVAL" || \
    fatal "Invalid AUTO_REARM_INTERVAL: ${AUTO_REARM_INTERVAL}"

###############################################################################
# Remove legacy second timer and old drop-ins
###############################################################################

rm -f /etc/systemd/system/rearm-boot.timer
rm -rf /etc/systemd/system/rearm.timer.d

###############################################################################
# Rearm Service
###############################################################################

cat > /etc/systemd/system/rearm.service <<EOF_SERVICE
[Unit]
Description=Smart DNS Rearm
After=network-online.target
Wants=network-online.target

[Service]
Type=oneshot
ExecStart=/bin/bash ${BASE_DIR}/rearm.sh
EOF_SERVICE

###############################################################################
# Single Rearm Timer
###############################################################################

cat > /etc/systemd/system/rearm.timer <<EOF_TIMER
[Unit]
Description=Automatic Smart DNS Rearm
After=network-online.target
Wants=network-online.target

[Timer]
# First automatic Rearm after boot.
OnBootSec=5min

# Periodic Rearm interval.
OnUnitActiveSec=${AUTO_REARM_INTERVAL}

AccuracySec=1min
Unit=rearm.service

[Install]
WantedBy=timers.target
EOF_TIMER

###############################################################################
# Reload systemd
###############################################################################

systemctl daemon-reload

###############################################################################
# Validate Units
###############################################################################

if command -v systemd-analyze >/dev/null 2>&1; then
    systemd-analyze verify \
        /etc/systemd/system/rearm.service \
        /etc/systemd/system/rearm.timer
fi

chmod +x "$BASE_DIR/rearm.sh"

success "systemd Rearm timer installed (${AUTO_REARM_INTERVAL})."
