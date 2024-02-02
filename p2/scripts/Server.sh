#!/bin/bash

echo -e "\033[1;3;34m--- Server script starting ---\033[0m"

apt-get update -y && apt-get install -y curl

echo -e "\033[1;32m--- Installing K3s ---\033[0m"

curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE="644" \
	sh -

if ! grep 'kubectl get all' /home/vagrant/.bashrc; then
	echo "echo
  echo -e '\033[1mkubectl get all:\033[0m'
  sudo kubectl get all" >>/home/vagrant/.bashrc
fi

echo -e "\033[1;3;34m--- Server script finished ---\033[0m"
