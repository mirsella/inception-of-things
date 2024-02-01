#!/bin/bash

echo "\033[1;3;33m--- Server Worker script starting ---\033[0m"

echo "\033[1;32m--- Setting up Hostname ---\033[0m"

echo "nguiardW" > /etc/hostname
sudo hostname -F /etc/hostname
echo "192.168.56.111 nguiardSW" | sudo tee -a /etc/hosts
sudo hostnamectl set-hostname nguiardSW

echo "\033[1;32m--- Setting up UFW ---\033[0m"

sudo apt install ufw -y
sudo ufw allow 6444
sudo ufw allow OpenSSH
sudo ufw --force enable
sudo ufw reload

echo "\033[1;32m--- Installing K3s ---\033[0m"

if [ ! -f /usr/local/bin/k3s ]
then
	curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE="644" \
									K3S_URL=https://192.168.56.110:6443 \
									K3S_TOKEN=$(sudo cat /vagrant/node-token) \
									sh -
else
	echo "\033[33;3mK3s is already installed\033[0m"
fi

# echo "\033[1;32m--- Getting nodes ---\033[0m"
# sudo k3s kubectl get node -v=10

echo "\033[1;3;33m--- Server Worker script finished ---\033[0m"
