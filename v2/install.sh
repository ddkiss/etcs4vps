#!/bin/bash
mkdir /etc/v2ray
mkdir /var/log/v2ray
bash <(curl -L -s https://install.direct/go.sh)
nano /etc/v2ray/config.json
systemctl start v2ray
systemctl status v2ray
