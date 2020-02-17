#!/bin/bash
mkdir /etc/caddy
touch /etc/caddy/Caddyfile
chown -R root:root /etc/caddy
mkdir /etc/ssl/caddy
chown -R root:www-data /etc/ssl/caddy
chmod 0770 /etc/ssl/caddy
mkdir /var/www
chown www-data:www-data /var/www
curl https://getcaddy.com | bash -s personal
nano /etc/caddy/Caddyfile
curl -s https://raw.githubusercontent.com/ddkiss/etcs4vps/master/Caddy/caddy.service -o /etc/systemd/system/caddy.service
systemctl daemon-reload
systemctl enable caddy.service
systemctl start caddy.service
systemctl status caddy.service
