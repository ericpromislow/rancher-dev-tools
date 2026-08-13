#!/bin/bash

set -exu

NGROK=eric.rancher.tomlebreux.com

helm repo list | grep -q cert-manager || helm repo add cert-manager https://charts.jetstack.io
# helm repo list | grep -q rancher-alpha || helm repo add rancher-alpha https://releases.rancher.com/server-charts/alpha
# helm repo list | grep -q rancher-latest || helm repo add rancher-latest https://releases.rancher.com/server-charts/latest
helm repo list | grep -q rancher-prime || helm repo add rancher-prime https://charts.rancher.com/server-charts/prime
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

REPLICA_COUNT=3
REPLICA_COUNT=1

RANCHER_VERSION=2.14.2
RANCHER_IMAGE_TAG=v2.14.2
CHART_PATH=rancher-prime/rancher

helm upgrade --install rancher "${CHART_PATH}" \
  --namespace cattle-system \
  --create-namespace \
#   --set rancherImage=$REPO/rancher \
#   --set rancherImageTag="${RANCHER_IMAGE_TAG}" \
#   --set agentTLSMode=system-store \
  --version "${RANCHER_VERSION}" \
#   --set tls=external \
  --set replicas=$REPLICA_COUNT \
  --set CATTLE_FEATURES=ui-sql-cache=true \
  --set hostname="$NGROK"

#  --set webhook=morspin/webhook:v01 \

#  --set rancherImageTag=v2.9-3c4ccdc5bc9fde3510089153b5ad58fdbe604880-head \
#@  --version 2.9.0-alpha7 \
