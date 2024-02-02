#!/bin/bash

if [ $(whoami) != root ]; then
	echo You must be root. Aborting
	exit 1
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
# https://stackoverflow.com/questions/68297354/what-is-the-default-password-of-argocd
echo "ArgoCD password:"
sudo kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 --decode
