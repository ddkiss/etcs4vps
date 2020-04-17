#!/bin/sh
read -p "method?(-L udp://:1053 -L tcp://:1053 -F relay://:12345)" METHOD1
echo "install gost"
snap install gost

echo "Generate /etc/systemd/system/gost.service"
cat <<EOF > /etc/systemd/system/gost.service
[Unit]
Description=gost
[Service]
ExecStart=/snap/bin/gost ${METHOD1}
Restart=always
User=root
[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload && systemctl enable gost.service && systemctl restart gost.service && systemctl status gost -l
