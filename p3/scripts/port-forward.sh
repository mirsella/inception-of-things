#!/bin/bash

if [ $(whoami) != root ]; then
	sudo bash "$0"
	exit
fi

kubectl port-forward service/argocd-server --address 0.0.0.0 -n argocd 8080:443 2>&1 >/dev/null &
