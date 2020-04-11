#!/bin/sh
#read -p "host name?" HOSTNAME
read -p "pwd?" PPWD
read -p "gost version(ex 2.11.0)?" VERNO
read -p "ssport?" S1PORT
read -p "s5port?" S2PORT


echo "download gost"
wget https://github.com/ginuerzh/gost/releases/download/v${VERNO}/gost-linux-amd64-${VERNO}.gz
gzip -d  gost-linux-amd64-${VERNO}.gz
mkdir /usr/bin/gost
mv gost-linux-amd64-${VERNO} /usr/bin/gost/gost
chmod +x /usr/bin/gost/gost

#echo "ln sslcert"
#ln -s /var/lib/caddy/.local/share/caddy/certificates/acme-v02.api.letsencrypt.org-directory/${HOSTNAME}/${HOSTNAME}.crt /usr/bin/gost/cert.pem
#ln -s /var/lib/caddy/.local/share/caddy/certificates/acme-v02.api.letsencrypt.org-directory/${HOSTNAME}/${HOSTNAME}.key /usr/bin/gost/key.pem

echo "Generate /etc/gost/config.json"
cat <<EOF > /etc/gost/config.json
{
    "ServeNodes": [
        "ss://AEAD_CHACHA20_POLY1305:${PPWD}@:${S1PORT}",
        "ssu://AEAD_CHACHA20_POLY1305:${PPWD}@:${S1PORT}",
        "socks5+tls://dd:${PPWD}@:${S2PORT}"
    ]
}
EOF

echo "Generate /etc/systemd/system/gost.service"
cat <<EOF > /etc/systemd/system/gost.service
[Unit]
Description=gost
[Service]
ExecStart=/usr/bin/gost/gost -C /etc/gost/config.json
Restart=always
User=root
[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload && systemctl enable gost.service && systemctl restart gost.service && systemctl status gost -l
