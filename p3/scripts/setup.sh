#!/bin/bash

if [ $(whoami) != root ]; then

	exit $(sudo bash "$0")
fi

if ! command -v k3d &>/dev/null; then
	echo "k3d could not be found"
	exit 1
fi
if ! command -v kubectl &>/dev/null; then
	echo "kubectl could not be found"
	exit 1
fi

if [ -d /vagrant ]; then
	cd /vagrant
fi

k3d cluster create --port 8888:8888

kubectl create namespace argocd
kubectl create namespace dev

kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

sleep 10

kubectl wait --timeout=200s --for=condition=Ready -n argocd --all pod

echo "ArgoCD password:"
kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 --decode
echo

bash scripts/port-forward.sh &
disown

kubectl apply -f confs/argocd-cm.yml -n argocd
kubectl apply -f confs/argocd-deploy.yml -n argocd

sleep 60
