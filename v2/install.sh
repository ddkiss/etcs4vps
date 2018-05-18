#!/bin/bash
mkdir /etc/v2ray
mkdir /var/log/v2ray
nano /etc/v2ray/config.json
bash <(curl -L -s https://install.direct/go.sh)
systemctl restart v2ray
systemctl status v2ray
