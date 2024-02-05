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


k3d cluster create bonus --port 8888:8888

kubectl create namespace argocd
kubectl create namespace dev
kubectl create namespace gitlab

# argoCD
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

sleep 10


if [ -f /vagrant/confs/argocd-deploy.yml ]; then
	kubectl apply -f /vagrant/confs/argocd-deploy.yml -n argocd
else
	kubectl apply -f "$(dirname "$0")/../confs/argocd-deploy.yml" -n argocd
fi

# Gitlab
helm repo add gitlab https://charts.gitlab.io/
helm repo update
helm upgrade --install gitlab gitlab/gitlab \
  --timeout 600s \
  --set global.edition=ce \
  --set global.hosts.domain=gitlab.local \
  --set global.hosts.externalIP=0.0.0.0 \
  --set global.hosts.https=false \
  --values https://gitlab.com/gitlab-org/charts/gitlab/-/raw/master/examples/values-minikube-minimum.yaml \
  --set certmanager-issuer.email=nguiard@student.42.fr \
  --set postgresql.image.tag=13.6.0 \
  -n gitlab

sleep 30

kubectl wait --timeout=200s --for=condition=Ready -n argocd --all pod
# https://stackoverflow.com/questions/68297354/what-is-the-default-password-of-argocd
echo -e "\033[1mArgoCD password:"
kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 --decode > argoCD.password
echo >> argoCD.password
cat argoCD.password
echo -e "Saved to argoCD.password\033[0m"

echo -e "\033[1mGitlab password:"
kubectl get secret gitlab-gitlab-initial-root-password -n gitlab -o jsonpath="{.data.password}" | base64 --decode > gitlab.password
echo >> gitlab.password
cat gitlab.password
echo -e "Saved to gitlab.password\033[0m"

# Port mapping
echo -e '\033[32mWaiting for argoCD to be ready (3min)\033[0m'
kubectl wait --for=condition=ready --timeout=180s pod -l app.kubernetes.io/name=argocd-server -n argocd
echo 'Port mapping argoCD 8080:433'
kubectl port-forward service/argocd-server --address 0.0.0.0 -n argocd 8080:443 2>&1 >/dev/null & disown
echo -e '\n\033[32mWaiting for Gitlab to be ready (10min)\033[0m'
kubectl wait --timeout=600s --for=condition=Ready -n gitlab --all pod
echo 'Port mapping Gitlab 8181:8181'
kubectl port-forward service/gitlab-webservice-default --address 0.0.0.0 -n gitlab 8181:8181 2>&1 >/dev/null & disown

sleep 1