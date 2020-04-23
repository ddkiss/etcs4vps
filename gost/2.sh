#!/bin/sh
read -p "-L method?(tcp://:993)" METHOD1
read -p "-F method?(relay://:990)" METHOD2
echo "install gost"
snap install gost
echo "Generate /snap/gost/config.json"
cat <<EOF > /snap/gost/config.json
{
    "ServeNodes": [
        "${METHOD1}"
    ],
	"ChainNodes": [
        "${METHOD2}"
    ],
	"Routes": [
        {
            "Retries": 1,
            "ServeNodes": [
            ],
            "ChainNodes": [           
            ]
        }        
    ]
}
EOF
echo "Generate /etc/systemd/system/gost.service"
cat <<EOF > /etc/systemd/system/gost.service
[Unit]
Description=gost
[Service]
ExecStart=/snap/bin/gost -C /snap/gost/config.json
Restart=always
User=root
[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload && systemctl enable gost.service && systemctl restart gost.service && systemctl status gost -l
