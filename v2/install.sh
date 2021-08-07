#!/bin/bash
mkdir /etc/v2ray
mkdir /var/log/v2ray
cat <<EOF > /etc/v2ray/datupdate.sh
bash <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-dat-release.sh)
EOF
chmod 777 /etc/v2ray/datupdate.sh
nano /etc/v2ray/config.json
bash <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh)
systemctl restart v2ray
systemctl status v2ray
chrontab -e
