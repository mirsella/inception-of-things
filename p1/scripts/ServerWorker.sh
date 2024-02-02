#!/bin/bash

echo "\033[1;3;33m--- Server Worker script starting ---\033[0m"

apt-get update -y && apt-get install -y curl

echo "\033[1;32m--- Installing K3s ---\033[0m"

# --flannel-iface is needed for k3s to communicate on our 'private_network' interface
curl -sfL https://get.k3s.io | K3S_URL="https://$SERVER_IP:6443" \
	K3S_TOKEN_FILE="/vagrant/node-token" \
	INSTALL_K3S_EXEC="--flannel-iface=eth1" \
	sh -

echo "\033[1;3;33m--- Server Worker script finished ---\033[0m"
