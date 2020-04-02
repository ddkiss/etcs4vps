#!/bin/sh
read -p "host name?" HOSTNAME
read -p "pwd?" PPWD
read -p "gost version(ex 2.11.0)?" VERNO

echo "download gost"
wget https://github.com/ginuerzh/gost/releases/download/v${VERNO}/gost-linux-amd64-${VERNO}.gz
gzip -d  gost-linux-amd64-${VERNO}.gz
mkdir /usr/bin/gost
mv gost-linux-amd64-${VERNO} /usr/bin/gost/gost
chmod +x /usr/bin/gost/gost

echo "ln sslcert"
ln -s /var/lib/caddy/.local/share/caddy/certificates/acme-v02.api.letsencrypt.org-directory/${HOSTNAME}/${HOSTNAME}.crt /usr/bin/gost/cert.pem
ln -s /var/lib/caddy/.local/share/caddy/certificates/acme-v02.api.letsencrypt.org-directory/${HOSTNAME}/${HOSTNAME}.key /usr/bin/gost/key.pem

echo "Generate /etc/systemd/system/gost.service"
cat <<EOF > /etc/systemd/system/gost.service
[Unit]
DescriptiON=gost
[Service]
ExecStart=/usr/bin/gost/gost -L=ss://AEAD_CHACHA20_POLY1305:${PPWD}@:156 -L=socks5+tls://dd:${PPWD}@${HOSTNAME}:993?cert=/usr/bin/gost/cert.pem&key=/usr/bin/gost/key.pem
Restart=always
User=root
[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload && systemctl enable gost.service && systemctl restart gost.service && systemctl status gost -l
