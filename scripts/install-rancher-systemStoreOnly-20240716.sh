#!/bin/bash

flip() {
    echo $1
    exit 1
}

# kubectl get ns | grep -s cattle &&
#    kubectl get pods -n cattle-system &&
#    flip 'rancher already installed?'


set -exu

NGROK2=eric.rancher.tomlebreux.com

if [[ -z "${NGROK2:-}" ]] ; then
  case "${1:-localhost}" in
    localhost) ;;
    *) pgrep -f 'ngrok http --inspect=false https://localhost:7?443' || flip 'ngrok not running' ;;
  esac

  NGROK=$1
  case $NGROK in
    localhost) NGROK1=localhost ;;
    *) NGROK1="${NGROK}".ngrok.app ;;
  esac
  NGROK=$NGROK1
else
  NGROK=$NGROK2
fi

helm repo list | grep -q cert-manager || helm repo add cert-manager https://charts.jetstack.io
helm repo list | grep -q rancher-alpha || helm repo add rancher-alpha https://releases.rancher.com/server-charts/alpha
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

REPO=rancher

# 2.9.2-alpha2 digital ocean creds fail, so go back to 2.9.1z

RANCHER_VERSION=2.9.2-alpha2
RANCHER_IMAGE_TAG=v2.9.2-alpha2
CHART_PATH=rancher-alpha/rancher

# 2.9.2-alpha2 digital ocean creds fail, so go back to 2.9.1z

RANCHER_VERSION=2.9.1
RANCHER_IMAGE_TAG=v2.9.1
CHART_PATH=rancher-latest/rancher

RANCHER_VERSION=2.9.2
RANCHER_IMAGE_TAG=v2.9.2
CHART_PATH=rancher-latest/rancher

# 2.9.1 -- can't create a downstream cluster with flannel - the downstream node 
# never starts up a connection....

# First 2.10 release...

RANCHER_VERSION=2.10.0-alpha2
RANCHER_IMAGE_TAG=v2.10.0-alpha2
CHART_PATH=rancher-alpha/rancher

RANCHER_VERSION=2.11.0-alpha8
RANCHER_IMAGE_TAG=v2.12.0-dev-vai-arm64.25
CHART_PATH=rancher-alpha/rancher

RANCHER_VERSION=2.10.3
RANCHER_IMAGE_TAG=v2.10.3
CHART_PATH=rancher-latest/rancher

RANCHER_VERSION=2.11.3
RANCHER_IMAGE_TAG=v2.11.3
CHART_PATH=rancher-latest/rancher

RANCHER_VERSION=2.12.1
RANCHER_IMAGE_TAG=v2.12.1
CHART_PATH=rancher-latest/rancher

RANCHER_VERSION=2.13.0
RANCHER_IMAGE_TAG=v2.13.0
CHART_PATH=rancher-latest/rancher

RANCHER_VERSION=2.13.1
RANCHER_IMAGE_TAG=v2.13.1
CHART_PATH=rancher-latest/rancher

RANCHER_VERSION=2.13.2-alpha3
RANCHER_IMAGE_TAG=v2.13.2-alpha3
CHART_PATH=rancher-alpha/rancher

RANCHER_VERSION=2.13.1
RANCHER_IMAGE_TAG=v2.13.1
CHART_PATH=rancher-latest/rancher

REPLICA_COUNT=3
REPLICA_COUNT=1

RANCHER_VERSION=2.14.2
RANCHER_IMAGE_TAG=v2.14.2
CHART_PATH=rancher-latest/rancher

helm upgrade --install rancher "${CHART_PATH}" \
  --namespace cattle-system \
  --create-namespace \
  --set rancherImage=$REPO/rancher \
  --set rancherImageTag="${RANCHER_IMAGE_TAG}" \
  --set agentTLSMode=system-store \
  --version "${RANCHER_VERSION}" \
  --set tls=external \
  --set replicas=$REPLICA_COUNT \
  --set CATTLE_FEATURES=ui-sql-cache=true \
  --set hostname="$NGROK"

#  --set webhook=morspin/webhook:v01 \

#  --set rancherImageTag=v2.9-3c4ccdc5bc9fde3510089153b5ad58fdbe604880-head \
#@  --version 2.9.0-alpha7 \
