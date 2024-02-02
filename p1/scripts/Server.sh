#!/bin/bash

echo -e "\033[1;3;34m--- Server script starting ---\033[0m"

apt-get update -y && apt-get install -y curl

echo -e "\033[1;32m--- Installing K3s ---\033[0m"

# --flannel-iface is needed for k3s to communicate on our 'private_network' interface
curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE="644" \
	INSTALL_K3S_EXEC="--node-ip=$SERVER_IP --flannel-iface=eth1" \
	sh -
sudo cp -v /var/lib/rancher/k3s/server/node-token /vagrant/

if ! grep 'kubectl get all' /home/vagrant/.bashrc; then
	echo "
  echo
  echo -e '\033[1mkubectl get node -o wide:\033[0m'
  sudo kubectl get node -o wide
  echo
  echo -e '\033[1mifconfig eth1 (ip addr | grep 'eth1:' -A 6):\033[0m'
  ip addr | grep 'eth1:' -A 6
  " >>/home/vagrant/.bashrc
fi

echo -e "\033[1;3;34m--- Server script finished ---\033[0m"
