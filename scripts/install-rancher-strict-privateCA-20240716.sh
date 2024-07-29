#!/bin/bash

flip() {
    echo $1
    exit 1
}

# kubectl get ns | grep -s cattle &&
#    kubectl get pods -n cattle-system &&
#    flip 'rancher already installed?'


set -exu

case "${1:-localhost}" in
localhost) ;;
*) pgrep -f 'ngrok http --inspect=false https://localhost:443' || flip 'ngrok not running' ;;
esac

NGROK=$1
case $NGROK in
    localhost) NGROK1=localhost ;;
    *) NGROK1="${NGROK}".ngrok.app ;;
esac


kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.15.0/cert-manager.crds.yaml

helm repo list | grep -q cert-manager || helm repo add cert-manager https://charts.jetstack.io
helm repo list | grep -q rancher-alpha || helm repo add rancher-alpha https://releases.rancher.com/server-charts/alpha
helm repo add jetstack https://charts.jetstack.io

# Update your local Helm chart repository cache
helm repo update

# Install the cert-manager Helm chart
helm upgrade --install cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.15.0

kubectl get namespaces | grep cattle-system || kubectl create namespace cattle-system
kubectl -n cattle-system create secret generic tls-ca \
  --from-file=cacerts.pem=$HOME/lab/rancher/cacerts.pem

helm upgrade --install rancher rancher-alpha/rancher --devel \
  --namespace cattle-system \
  --set hostname="$NGROK1" \
  --set rancherImage=rancher/rancher \
  --set rancherImageTag=v2.9-3c4ccdc5bc9fde3510089153b5ad58fdbe604880-head \
  --version 2.9.0-alpha7 \
  --set agentTLSMode=strict \
  --set privateCA=true \
  --set tls=external

#  --set ingress.tls.source=letsEncrypt \
#  --set letsEncrypt.email=ericp@lirdle.com \
#  --set letsEncrypt.ingress.class=nginx \
