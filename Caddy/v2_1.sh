#!/bin/bash
read -p "caddyLas_subDir(2.0.0-rc.2)" CURI
read -p "host name?" HOSTNAME
read -p "eamil? " SSLMAIL

wget https://github.com/caddyserver/caddy/releases/download/v${CURI}/caddy_${CURI}_linux_amd64.tar.gz
tar -xzvf caddy_${CURI}_linux_amd64.tar.gz
mv ./caddy /usr/bin/caddy
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

echo "Generate /etc/caddy/caddyfile"
cat <<EOF > /etc/caddy/caddyfile
{
email ${SSLMAIL}
}
http://127.0.0.1:81,
${HOSTNAME}
{
root * /var/www
file_server
reverse_proxy /pconf localhost:10029
}
EOF


echo "Generate /etc/systemd/system/caddy.service"
cat <<EOF > /etc/systemd/system/caddy.service
[Unit]
Description=Caddy Web Server
Documentation=https://caddyserver.com/docs/
After=network.target
[Service]
User=caddy
Group=caddy
ExecStart=/usr/bin/caddy run --config /etc/caddy/caddyfile --adapter caddyfile --environ
ExecReload=/usr/bin/caddy run --config /etc/caddy/caddyfile --adapter caddyfile
TimeoutStopSec=5s
LimitNOFILE=1048576
LimitNPROC=512
PrivateTmp=true
ProtectSystem=full
AmbientCapabilities=CAP_NET_BIND_SERVICE
[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload && systemctl enable caddy.service && systemctl restart caddy.service && systemctl status caddy -l
