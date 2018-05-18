#!/bin/bash
ulimit -n 8192
mkdir /etc/caddy
touch /etc/caddy/Caddyfile
chown -R root:www-data /etc/caddy
mkdir /etc/ssl/caddy
chown -R www-data:root /etc/ssl/caddy
mkdir /var/www
chown www-data:www-data /var/www
curl https://getcaddy.com | bash -s personal http.forwardproxy
nano /etc/caddy/Caddyfile
curl -s https://raw.githubusercontent.com/ddkiss/etcs4vps/master/Caddy/caddy.service -o /etc/systemd/system/caddy.service
systemctl daemon-reload
systemctl enable caddy.service
systemctl start caddy.service
systemctl status caddy.service
