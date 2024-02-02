#!/bin/bash

echo -e "\033[1;3;33m--- App 2 script starting ---\033[0m"

apt-get update -y && apt-get install -y curl

echo -e "\033[1;32m--- Installing K3s ---\033[0m"

# --flannel-iface is needed for k3s to communicate on our 'private_network' interface
curl -sfL https://get.k3s.io | K3S_URL="https://$SERVER_IP:6443" \
	K3S_TOKEN_FILE="/vagrant/node-token" \
	INSTALL_K3S_EXEC="--flannel-iface=eth1 --node-ip=192.168.56.110" \
	sh -

echo "
echo
echo -e '\033[1mifconfig eth1 (ip addr | grep 'eth1:' -A 6):\033[0m'
ip addr | grep 'eth1:' -A 6
" >> /home/vagrant/.bashrc

echo -e "\033[1;3;33m--- Server Worker script finished ---\033[0m"
