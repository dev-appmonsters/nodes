#!/bin/bash

set -x
SERVICE_NAME=bcore

# update packages and install bitcoind
sudo add-apt-repository ppa:bitcoin/bitcoin -y
sudo apt-get update -y
sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confnew" dist-upgrade -y
sudo apt-get install bitcoind -y

# fix ownership and permissions
sudo chown root:root etc/systemd/system/bitcoin.service
sudo chmod 664 etc/systemd/system/bitcoin.service

# install templates
sudo rsync -arv etc/ /etc/

# prepare directories, user and permissions
sudo mkdir /var/{lib,log,run}/bitcoin
sudo useradd -r -s /bin/false -d /var/lib/bitcoin bitcoin
[[ ! $(grep bitcoin /etc/group) ]] && (sudo groupadd bitcoin && sudo usermod -aG bitcoin bitcoin)
echo "umask 037" | sudo tee /var/lib/bitcoin/.profile
sudo chown -R bitcoin:bitcoin /var/{lib,log,run}/bitcoin
sudo find /var/lib/bitcoin -type f -exec chmod 640 {} \;
sudo find /var/lib/bitcoin -type d -exec chmod 750 {} \;
sudo ln -s /var/lib/bitcoin/debug.log /var/log/bitcoin/debug.log
sudo ln -s /var/lib/bitcoin/db.log /var/log/bitcoin/db.log
sudo touch /var/lib/bitcoin/debug.log
sudo touch /var/lib/bitcoin/db.log
sudo chown root:bitcoin /var/log/bitcoin/*
sudo chmod 660 /var/log/bitcoin/*
sudo chown root:bitcoin /etc/bitcoin.conf
sudo chmod 640 /etc/bitcoin.conf

# service install
sudo systemctl daemon-reload
sudo systemctl enable bitcoin
