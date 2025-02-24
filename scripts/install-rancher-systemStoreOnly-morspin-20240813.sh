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
helm repo list | grep -q rancher-latest || helm repo add rancher-latest https://releases.rancher.com/server-charts/latest
helm repo list | grep -q jetstack || helm repo add jetstack https://charts.jetstack.io

# Update your local Helm chart repository cache
helm repo update

# Install the cert-manager Helm chart
helm upgrade --install cert-manager cert-manager/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --set crds.enabled=true --set "extraArgs[0]=--enable-certificate-owner-ref=true" --wait --timeout=10m

kubectl rollout status --namespace cert-manager deploy/cert-manager --timeout 1m

REPO=morspin

RANCHER_VERSION=2.9.2
RANCHER_IMAGE_TAG=v2.9.2
CHART_PATH=rancher-latest/rancher

RANCHER_VERSION=2.10.0-alpha2
# RANCHER_IMAGE_TAG=v2.10.0-alpha2
RANCHER_IMAGE_TAG=v2.10.0-dev.20
CHART_PATH=rancher-alpha/rancher

RANCHER_VERSION=2.10.0
RANCHER_IMAGE_TAG=v2.10.0-dev.21
CHART_PATH=rancher-latest/rancher


RANCHER_VERSION=2.10.0-alpha2
RANCHER_IMAGE_TAG=v2.10.0-dev-arm64.38
CHART_PATH=rancher-alpha/rancher

REPLICA_COUNT=3
REPLICA_COUNT=1

#REPO=rancher
#RANCHER_IMAGE_TAG=v2.9.1-rc2

helm upgrade --install rancher "${CHART_PATH}" \
  --namespace cattle-system \
  --create-namespace \
  --set rancherImage="$REPO/rancher" \
  --set rancherImageTag="${RANCHER_IMAGE_TAG}" \
  --set agentTLSMode=system-store \
  --set CATTLE_LOGLEVEL=debug \
  --version "${RANCHER_VERSION}" \
  --set tls=external \
  --set replicas=$REPLICA_COUNT \
  --set hostname="$NGROK1"

#  --set webhook=morspin/webhook:v01 \

#  --set rancherImageTag=v2.9-3c4ccdc5bc9fde3510089153b5ad58fdbe604880-head \
#@  --version 2.9.0-alpha7 \
