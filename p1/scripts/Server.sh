#!/bin/bash

echo "\033[1;3;34m--- Server script starting ---\033[0m"

apt-get update -y && apt-get install -y curl

echo "\033[1;32m--- Installing K3s ---\033[0m"

# --flannel-iface is needed for k3s to communicate on our 'private_network' interface
curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE="644" \
	INSTALL_K3S_EXEC="--node-ip=$SERVER_IP --flannel-iface=eth1" \
	sh -
sudo cp -v /var/lib/rancher/k3s/server/node-token /vagrant/

echo "
echo
echo 'kubectl get node -o wide: '
sudo kubectl get node -o wide
" >>/home/vagrant/.bashrc

echo "\033[1;3;34m--- Server script finished ---\033[0m"
