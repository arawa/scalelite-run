#!/bin/bash
COMPOSE=""
if [ "$1" == "storage" ]; then
    echo "Setting with storage option"
	COMPOSE=" --file docker-compose.recording.yml"
else
    echo "Setting without storage option"
fi
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
ExecStart=/usr/local/bin/docker-compose ${COMPOSE} up -d --remove-orphans

ExecStop=/usr/local/bin/docker-compose down

[Install]
WantedBy=multi-user.target
" > /etc/systemd/system/scalelite.service

systemctl enable scalelite
service scalelite start
service scalelite status