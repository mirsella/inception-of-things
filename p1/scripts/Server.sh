#!/bin/bash

echo "\033[1;3;34m--- Server script starting ---\033[0m"

echo "\033[1;32m--- Setting up Hostname ---\033[0m"

echo "nguiardS" > /etc/hostname
sudo hostname -F /etc/hostname
echo "192.168.56.110 nguiardS" | sudo tee -a /etc/hosts
sudo hostnamectl set-hostname nguiardS

echo "\033[1;32m--- Setting up UFW ---\033[0m"

sudo apt install ufw -y
sudo ufw allow 6443
sudo ufw allow OpenSSH
sudo ufw --force enable
sudo ufw reload

echo "\033[1;32m--- Installing K3s ---\033[0m"

if [ ! -f /usr/local/bin/k3s ]
then
	curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE="644" \
								sh - &

	sleep 10
	sudo journalctl -u k3s -f &
	while [ ! -f /vagrant/node-token ]
	do
		sleep 4
		sudo cp /var/lib/rancher/k3s/server/node-token /vagrant/node-token
		sudo chmod 644 /vagrand/node-token
	done
else
	echo "\033[33;3mK3s is already installed\033[0m"
fi

# echo "\033[1;32m--- Getting nodes ---\033[0m"
# sudo k3s kubectl get node

echo "\033[1;3;34m--- Server script finished ---\033[0m"