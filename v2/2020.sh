#!/bin/sh
read -p "host name?" HOSTNAME
read -p "SSpwd?" SPWD
read -p "ssport?" SPORT
read -p "V2uid?" VUID
mkdir /etc/v2ray
mkdir /var/log/v2ray
echo "Generate /etc/v2ray/config.json"
cat <<EOF > /etc/v2ray/config.json
{
    "log": {
        "loglevel": "warning",
        "access": "/var/log/v2ray/access.log",
        "error": "/var/log/v2ray/error.log"
    },
    "dns": {
        "servers": [
            "https+local://1.1.1.1/dns-query",
            "localhost"
        ]
    },
    "inbounds": [
        {
            "port": 10029,
            "listen": "127.0.0.1",
            "protocol": "vmess",
            "settings": {
                "clients": [
                    {
                        "id": "${VUID}",
                        "alterId": 16
                    }
                ]
            },
            "streamSettings": {
                "network": "ws",
                "security": "none",
                "wsSettings": {
                    "path": "/pconf",
                    "headers": {
                        "Host": "${HOSTNAME}"
                    }
                }
            }
        },
        {
            "port": ${SPORT},
            "tag": "ss",
            "protocol": "shadowsocks",
            "settings": {
                "method": "chacha20-ietf-poly1305",
                "password": "${SPWD}",
                "network": "tcp,udp"
            }
        }
    ],
    "outbounds": [
        {
            "protocol": "freedom",
            "settings": {
                "domainStrategy": "UseIP"
            }
        },
        {
            "protocol": "blackhole",
            "settings": {
                
            },
            "tag": "blocked"
        }
    ],
    "routing": {
        "domainStrategy": "IPIfNonMatch",
        "rules": [
            {
                "type": "field",
                "ip": [
                    "geoip:private"
                ],
                "outboundTag": "blocked"
            }
        ]
    }
}
EOF
bash <(curl -L -s https://install.direct/go.sh)
systemctl restart v2ray
systemctl status v2ray
