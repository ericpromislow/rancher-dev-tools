#!/bin/bash

flip() {
    echo $1
    exit 1
}


set -exu

case "${1:-localhost}" in
localhost) ;;
*) pgrep -f 'ngrok http --inspect=false https://localhost:7?443' || flip 'ngrok not running' ;;
esac

# NGROK=$1
# case $NGROK in
#     localhost) NGROK1=localhost ;;
#     *) NGROK1="${NGROK}".ngrok.app ;;
# esac

NGROK1=eric.rancher.tomlebreux.com

helm repo list | grep -q cert-manager || helm repo add cert-manager https://charts.jetstack.io
helm repo list | grep -q rancher-alpha || helm repo add rancher-alpha https://releases.rancher.com/server-charts/alpha
helm repo list | grep -q rancher-latest || helm repo add rancher-latest https://releases.rancher.com/server-charts/latest
helm repo list | grep -q jetstack || helm repo add jetstack https://charts.jetstack.io
helm repo list | grep -q e2e-rancher-communityalpha || helm repo add e2e-rancher-communityalpha	https://releases.rancher.com/server-charts/alpha   

helm repo update
 
# Install the cert-manager Helm chart
helm upgrade --install cert-manager cert-manager/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --set crds.enabled=true --set "extraArgs[0]=--enable-certificate-owner-ref=true" --wait --timeout=10m

kubectl rollout status --namespace cert-manager deploy/cert-manager --timeout 1m

RANCHER_VERSION=2.14.0-alpha13
CHART_PATH=e2e-rancher-communityalpha/rancher

RANCHER_VERSION=2.14.2
CHART_PATH=rancher-latest/rancher

helm upgrade --install rancher $CHART_PATH \
  --version $RANCHER_VERSION \
  --namespace cattle-system --create-namespace \
  --set hostname="$NGROK1" \
  --wait --timeout=10m \
  --set replicas=1 \

#   Failed:
# Error: UPGRADE FAILED: resource not ready, name: rancher, kind: Deployment, status: InProgress
# context deadline exceeded

# Remove this:
#  --set ingress.tls.source=secret --set privateCA=true \
