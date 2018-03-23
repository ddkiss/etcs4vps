#!bin/bash
mkdir /etc/caddy
mkdir /etc/ssl/caddy
mkdir /var/www
curl https://getcaddy.com | bash -s personal
curl -s https://raw.githubusercontent.com/ddkiss/etcs4vps/master/Caddy/caddy.service -o /etc/systemd/system/caddy.service
nano /etc/caddy/Caddyfile
systemctl daemon-reload
systemctl enable caddy.service
systemctl start caddy.service
systemctl status caddy.service
