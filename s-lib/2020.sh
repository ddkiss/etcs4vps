#!/bin/sh
read -p "server?(0.0.0.0) " HOSTNAME
read -p "port? " SPORT
read -p "pwd? " PPWD
echo "Generate /snap/shadowsocks-libev/config.json"
cat <<EOF > /snap/shadowsocks-libev/config.json
{
    "server":"${HOSTNAME}",
    "server_port":${SPORT},
    "password":"${PPWD}",
    "timeout":60,
    "method":"chacha20-ietf-poly1305",
    "fast_open":false,
    "mode":"tcp_and_udp"
}
EOF
echo "Generate /etc/systemd/system/shadowsocks-libev.service"
cat <<EOF > /etc/systemd/system/shadowsocks-libev.service
[Unit]
Description=Shadowsocks-Libev Server Service
After=network.target

[Service]
Type=simple
ExecStart=/snap/bin/shadowsocks-libev.ss-server -c /snap/shadowsocks-libev/config.json

[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload && systemctl enable shadowsocks-libev.service && systemctl restart shadowsocks-libev.service && systemctl status shadowsocks-libev -l
