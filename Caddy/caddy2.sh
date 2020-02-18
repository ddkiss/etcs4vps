#!/bin/bash
wget https://github.com/caddyserver/caddy/releases/download/v2.0.0-beta.14/caddy2_beta14_linux_amd64
mv ./caddy2_beta14_linux_amd64 /usr/bin/caddy
caddy version
groupadd --system caddy
useradd --system \
	--gid caddy \
	--create-home \
	--home-dir /var/lib/caddy \
	--shell /usr/sbin/nologin \
	--comment "Caddy web server" \
	caddy
touch /etc/caddy/Caddyfile
cat>/etc/caddy/Caddyfile<<EOF
127.0.0.1:81
root /var/www
EOF
curl -s https://raw.githubusercontent.com/caddyserver/dist/master/init/caddy.service -o /etc/systemd/system/caddy.service
systemctl daemon-reload
systemctl enable caddy
systemctl start caddy
systemctl status caddy
