#!/bin/bash

if [ $(whoami) != root ]; then
	sudo bash "$0"
	exit
fi

if ! command -v k3d &>/dev/null; then
	echo "k3d could not be found"
	exit
fi
if ! command -v kubectl &>/dev/null; then
	echo "kubectl could not be found"
	exit
fi

k3d cluster create -p 80:80@loadbalancer -p 443:443@loadbalancer

kubectl create namespace argocd
kubectl create namespace dev

kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

sleep 10

kubectl wait --timeout=200s --for=condition=Ready -n argocd --all pod

# https://stackoverflow.com/questions/68297354/what-is-the-default-password-of-argocd
echo "ArgoCD password:"
kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 --decode
echo

kubectl port-forward -n argocd service/argocd-server --address 0.0.0.0 8080:443 &
disown
