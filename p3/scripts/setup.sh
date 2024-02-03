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

k3d cluster create --port 8888:8888

kubectl create namespace argocd
kubectl create namespace dev

kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

sleep 10

kubectl wait --timeout=200s --for=condition=Ready -n argocd --all pod

# https://stackoverflow.com/questions/68297354/what-is-the-default-password-of-argocd
echo "ArgoCD password:"
kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 --decode
echo

if [ -f /vagrant/scripts/port-forward.sh ]; then
	bash /vagrant/scripts/port-forward.sh
else
	bash "$(dirname "$0")/port-forward.sh"
fi

if [ -f /vagrant/argocd-deploy.yml ]; then
	kubectl apply -f /vagrant/argocd-deploy.yml -n argocd
else
	kubectl apply -f "$(dirname "$0")/argocd-deploy.yml" -n argocd
fi

sleep 60
