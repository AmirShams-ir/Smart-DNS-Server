install -m644 \
    "$BASE_DIR/systemd/rearm.service" \
    /etc/systemd/system/

install -m644 \
    "$BASE_DIR/systemd/rearm.timer" \
    /etc/systemd/system/

systemctl daemon-reload