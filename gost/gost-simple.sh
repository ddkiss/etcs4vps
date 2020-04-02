#!/bin/sh
read -p "gost version(ex 2.11.0)?" VERNO
read -p "METHOD?" METHOD


echo "download gost"
wget https://github.com/ginuerzh/gost/releases/download/v${VERNO}/gost-linux-amd64-${VERNO}.gz
gzip -d  gost-linux-amd64-${VERNO}.gz
mkdir /usr/bin/gost
mv gost-linux-amd64-${VERNO} /usr/bin/gost/gost
chmod +x /usr/bin/gost/gost

echo "Generate /etc/systemd/system/gost.service"
cat <<EOF > /etc/systemd/system/gost.service
[Unit]
DescriptiON=gost
[Service]
ExecStart=/usr/bin/gost/gost ${METHOD}
Restart=always
User=root
[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload && systemctl enable gost.service && systemctl restart gost.service && systemctl status gost -l
