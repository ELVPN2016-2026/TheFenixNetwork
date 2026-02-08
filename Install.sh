#!/bin/bash

# 1. Preparación y Dependencias
apt update && apt upgrade -y
apt install -y curl wget unzip python3-pip

# 2. Instalación del Core (V2Ray v5.44.1)
wget -O v2ray.zip https://github.com/v2fly/v2ray-core/releases/download/v5.44.1/v2ray-linux-64.zip
mkdir -p /usr/bin/v2ray
unzip -o v2ray.zip -d /usr/bin/v2ray
chmod +x /usr/bin/v2ray/v2ray
rm -f v2ray.zip

# 3. Configuración del Servicio Fénix
mkdir -p /etc/v2ray
# Crear un config base si no existe
if [ ! -f /etc/v2ray/config.json ]; then
    echo '{"inbounds":[{"port":10086,"protocol":"vmess","settings":{"clients":[{"id":"b831381d-6324-4d53-ad4f-8cda48b30811"}]}}],"outbounds":[{"protocol":"freedom","settings":{}}]}' > /etc/v2ray/config.json
fi

cat <<EOF > /etc/systemd/system/v2ray.service
[Unit]
Description=V2Ray Service By Fenix
After=network.target nss-lookup.target

[Service]
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/bin/v2ray/v2ray run -c /etc/v2ray/config.json
Restart=on-failure
RestartPreventExitStatus=23

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable v2ray
systemctl restart v2ray

# 4. INSTALACIÓN DE TU PANEL (EL CEREBRO)
# Instalamos la base del panel para que tenga las librerías necesarias
curl -L https://raw.githubusercontent.com/sprov065/v2ray-util/master/install.sh -o install_base.sh && bash install_base.sh
rm -f install_base.sh

# Sobrescribimos con TU respaldo de GitHub (Parchado y con Banner)
wget -O FenixV2ray.tar.gz https://raw.githubusercontent.com/ELVPN2016-2026/TheFenixNetwork/main/FenixV2ray.tar.gz
tar -xzvf FenixV2ray.tar.gz -C /
chmod +x /usr/bin/vp
rm FenixV2ray.tar.gz

clear
echo -e "\e[1;35m=======================================================\e[0m"
echo -e "\e[1;33m      FENIX V2RAY SISTEMA COMPLETO INSTALADO          \e[0m"
echo -e "\e[1;36m           Escribe 'vp' para iniciar                  \e[0m"
echo -e "\e[1;35m=======================================================\e[0m"
