#!/bin/bash
mkdir /etc/v2ray
mkdir /var/log/v2ray
nano /etc/v2ray/config.json
bash <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh)
systemctl restart v2ray
systemctl status v2ray
