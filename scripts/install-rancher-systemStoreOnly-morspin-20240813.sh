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
NGROK1=$NGROK2
NGROK=$NGROK2

helm repo list | grep -q cert-manager || helm repo add cert-manager https://charts.jetstack.io
helm repo list | grep -q rancher-alpha || helm repo add rancher-alpha https://releases.rancher.com/server-charts/alpha
helm repo list | grep -q rancher-latest || helm repo add rancher-latest https://releases.rancher.com/server-charts/latest
helm repo list | grep -q jetstack || helm repo add jetstack https://charts.jetstack.io

# helm repo list | grep -q rancher-head-2.14 || helm repo add rancher-head-2.14 https://charts.optimus.rancher.io/server-charts/release-2.14

# Update your local Helm chart repository cache
helm repo update

# Install the cert-manager Helm chart
helm upgrade --install cert-manager cert-manager/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --set crds.enabled=true --set "extraArgs[0]=--enable-certificate-owner-ref=true" --wait --timeout=10m

kubectl rollout status --namespace cert-manager deploy/cert-manager --timeout 1m

REPO=morspin

Y=159

RANCHER_VERSION=2.15.0
RANCHER_IMAGE_TAG="v2.15.0-dev-arm64.$Y"
CHART_PATH=rancher-latest/rancher

# REPO="${REPO:-rancher}"
REPO=rancher
REPO=morspin

# Remote dialer doesn't start up with this docker-built thing.  Try the linux builds...

# curl -sL https://releases.rancher.com/server-charts/alpha/index.yaml | yq '.entries.rancher[].version' | sort 
# curl -sL https://releases.rancher.com/server-charts/latest/index.yaml | yq '.entries.rancher[].version' | grep -v -e -rc -e -hotfix | sort

# Build notes:
# ARCH=arm64 REPO=morspin make quick

REPLICA_COUNT=3
REPLICA_COUNT=1

CATTLE_AGENT_IMAGE="$(echo $RANCHER_IMAGE_TAG | sed s/arm64/amd64/g)"

REPLICA_COUNT=3
REPLICA_COUNT=1

RANCHER_VERSION=2.14.2
RANCHER_IMAGE_TAG=v2.14.2
CHART_PATH=rancher-latest/rancher

Y=154
RANCHER_IMAGE_TAG=v2.14.2-dev-vai-arm64.${Y}

helm upgrade --install rancher "${CHART_PATH}" \
  --namespace cattle-system \
  --create-namespace \
  --set rancherImage="$REPO/rancher" \
  --set rancherImageTag="${RANCHER_IMAGE_TAG}" \
  --set agentTLSMode=system-store \
  --set CATTLE_LOGLEVEL=debug \
  --set CATTLE_AGENT_IMAGE="$CATTLE_AGENT_IMAGE" \
  --version "${RANCHER_VERSION}" \
  --set tls=external \
  --set replicas=$REPLICA_COUNT \
  --set hostname="$NGROK1"

#  --set webhook=morspin/webhook:v01 \

#  --set rancherImageTag=v2.9-3c4ccdc5bc9fde3510089153b5ad58fdbe604880-head \
#@  --version 2.9.0-alpha7 \
