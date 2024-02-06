#!/bin/bash

if [ $(whoami) != root ]; then
	exit $(sudo bash "$0")
fi

echo 'Port forwarding Gitlab 8181:8181'
kubectl port-forward service/gitlab-webservice-default --address 0.0.0.0 -n gitlab 8181:8181 2>/dev/null >/dev/null &

echo 'Port forwarding argoCD 8080:433'
kubectl port-forward service/argocd-server --address 0.0.0.0 -n argocd 8080:443 2>/dev/null >/dev/null &
