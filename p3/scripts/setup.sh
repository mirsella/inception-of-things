#!/bin/bash

if [ $(whoami) != root ]; then
	sudo "$0"
	exit 0
fi

if ! command -v k3d &>/dev/null; then
	echo "k3d could not be found"
	exit
fi
if ! command -v kubectl &>/dev/null; then
	echo "kubectl could not be found"
	exit
fi

k3d cluster create

kubectl create namespace argocd
kubectl create namespace dev

kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

kubectl wait --for=condition=Ready --all -n argocd pod

kubectl port-forward -n argocd service/argocd-server --address 0.0.0.0 8080:443 &

# https://stackoverflow.com/questions/68297354/what-is-the-default-password-of-argocd
echo "ArgoCD password:"
kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 --decode