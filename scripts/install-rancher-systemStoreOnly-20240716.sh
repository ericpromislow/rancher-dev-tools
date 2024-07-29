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

helm repo list | grep -q cert-manager || helm repo add cert-manager https://charts.jetstack.io
helm repo list | grep -q rancher-alpha || helm repo add rancher-alpha https://releases.rancher.com/server-charts/alpha
helm repo list | grep -q jetstack || helm repo add jetstack https://charts.jetstack.io

# Update your local Helm chart repository cache
helm repo update

# Install the cert-manager Helm chart
helm upgrade --install cert-manager cert-manager/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --set crds.enabled=true --set "extraArgs[0]=--enable-certificate-owner-ref=true" --wait --timeout=10m

RANCHER_VERSION=2.9.0-rc4
RANCHER_IMAGE_TAG=v2.9.0-rc4
RANCHER_IMAGE_TAG=v2.9-3c4ccdc5bc9fde3510089153b5ad58fdbe604880-head

RANCHER_VERSION=2.9
RANCHER_VERSION=2.9.0-alpha7
VERSIONTAG=v2.9.0-alpha7
RANCHER_IMAGE_TAG=v2.9-3c4ccdc5bc9fde3510089153b5ad58fdbe604880-head
CHART_PATH=rancher-alpha/rancher

helm upgrade --install rancher "${CHART_PATH}" --devel \
  --namespace cattle-system \
  --create-namespace \
  --set rancherImage=rancher/rancher \
  --set rancherImageTag="${RANCHER_IMAGE_TAG}" \
  --set agentTLSMode=system-store \
  --version "${RANCHER_VERSION}" \
  --set tls=external \
  --set hostname="$NGROK1"

#  --set rancherImageTag=v2.9-3c4ccdc5bc9fde3510089153b5ad58fdbe604880-head \
#@  --version 2.9.0-alpha7 \
