#!/bin/bash
echo "
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
ExecStart=/usr/bin/docker compose up -d --remove-orphans

ExecStop=/usr/bin/docker compose down

[Install]
WantedBy=multi-user.target
" > /etc/systemd/system/scalelite.service

systemctl enable scalelite
service scalelite start
service scalelite status
