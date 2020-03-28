#!/bin/bash
wget https://github.com/caddyserver/caddy/releases/download/v2.0.0-beta.20/caddy2_beta20_linux_amd64
mv ./caddy2_beta20_linux_amd64 /usr/bin/caddy
chmod -R 777 /usr/bin/caddy
caddy version
groupadd --system caddy
useradd --system \
	--gid caddy \
	--create-home \
	--home-dir /var/lib/caddy \
	--shell /usr/sbin/nologin \
	--comment "Caddy web server" \
	caddy
mkdir /etc/caddy
mkdir /var/www
touch /etc/caddy/Caddy.json
cat>/etc/caddy/Caddy.json<<EOF
{"apps":{"http":{"servers":{"example":{"listen":["127.0.0.1:81"],"routes":[{"handle":[{"handler":"vars","root":"/var/www"},{"handler":"file_server"$}]}]}}}}}
EOF
touch /etc/systemd/system/caddy.service
cat>/etc/systemd/system/caddy.service<<EOF
[Unit]
Description=Caddy Web Server
Documentation=https://caddyserver.com/docs/
After=network.target

[Service]
User=caddy
Group=caddy
ExecStart=/usr/bin/caddy run --config /etc/caddy/Caddy.json --environ
ExecReload=/usr/bin/caddy reload --config /etc/caddy/Caddy.json
TimeoutStopSec=5s
LimitNOFILE=1048576
LimitNPROC=512
PrivateTmp=true
ProtectSystem=full
AmbientCapabilities=CAP_NET_BIND_SERVICE

[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl enable caddy
systemctl start caddy
systemctl status caddy
