#!/bin/bash

if [ $(whoami) != root ]; then
	sudo bash "$0"
	exit
fi

kubectl port-forward -n argocd service/argocd-server --address 0.0.0.0 8080:443 &
disown
