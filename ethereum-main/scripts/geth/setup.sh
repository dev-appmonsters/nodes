#!/bin/bash

set -x
SERVICE_NAME=geth

# update packages and install geth
sudo add-apt-repository ppa:ethereum/ethereum -y
sudo apt-get update -y
sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confnew" dist-upgrade -y
sudo apt-get install ethereum -y

# fix ownership and permissions
sudo chown root:root etc/systemd/system/geth.service
sudo chmod 664 etc/systemd/system/geth.service

# install templates
sudo rsync -arv etc/ /etc/

# prepare directories, user and permissions
sudo mkdir /var/{lib,log,run}/geth
sudo useradd -r -s /bin/false -d /var/lib/geth geth
[[ ! $(grep geth /etc/group) ]] && (sudo groupadd geth && sudo usermod -aG geth geth)
echo "umask 037" | sudo tee /var/lib/geth/.profile
sudo chown -R geth:geth /var/{lib,log,run}/geth
sudo find /var/lib/geth -type f -exec chmod 640 {} \;
sudo find /var/lib/geth -type d -exec chmod 750 {} \;

# service install
sudo systemctl daemon-reload
sudo systemctl enable geth