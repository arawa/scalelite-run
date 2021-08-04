cat <<'EOF' | tee /etc/systemd/system/greenlight.service
[Unit]
Description=Scalelite
After=network-online.target
Wants=network-online.target
Requires=docker.service
After=docker.service

[Service]
Type=oneshot
RemainAfterExit=true
WorkingDirectory=/root/scalelite
ExecStart=/usr/local/bin/docker-compose up -d --remove-orphans
ExecStop=/usr/local/bin/docker-compose down

[Install]
WantedBy=multi-user.target
EOF

echo "Please do not forger to enable the service :) "