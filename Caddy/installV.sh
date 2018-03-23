#!/bin/bash
mkdir /etc/v2ray
nano /etc/v2ray/config.json
bash <(curl -L -s https://install.direct/go.sh)
systemctl enable v2ray
systemctl start v2ray
systemctl status v2ray
