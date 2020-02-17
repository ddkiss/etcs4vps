#!/bin/bash
mkdir /etc/traefik
mkdir /etc/traefik/dy
mkdir /usr/bin/traefik
wget https://github.com/containous/traefik/releases/download/v2.1.4/traefik_v2.1.4_linux_amd64.tar.gz
tar -zxvf traefik_v2.1.4_linux_amd64.tar.gz -C /usr/bin/traefik
nano /etc/traefik/traefik.toml
nano /etc/traefik/dy/1.toml
curl -s https://raw.githubusercontent.com/ddkiss/etcs4vps/master/trae/traefik.service -o /etc/systemd/system/traefik.service
systemctl daemon-reload
systemctl enable traefik
systemctl start traefik
systemctl status traefik
