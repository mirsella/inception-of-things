#!/bin/bash

echo "\033[1;3;34m--- Server script starting ---\033[0m"

echo "\033[1;32m--- Setting up Hostname ---\033[0m"

echo "nguiardS" > /etc/hostname
sudo hostname -F /etc/hostname
echo "192.168.56.110 nguiardS" | sudo tee -a /etc/hosts
sudo hostnamectl set-hostname nguiardS

echo "\033[1;32m--- Installing K3s ---\033[0m"

if [ ! -f /usr/local/bin/k3s ]
then
	curl -sfL https://get.k3s.io | K3S_TOKEN=test \
								sh -
else
	echo "\033[33;3mK3s is already installed\033[0m"
fi

echo "\033[1;32m--- Getting nodes ---\033[0m"
sudo k3s kubectl get node

echo "\033[1;3;34m--- Server script finished ---\033[0m"