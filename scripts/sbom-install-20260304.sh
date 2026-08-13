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
*) pgrep -f 'ngrok http --inspect=false https://localhost:7?443' || flip 'ngrok not running' ;;
esac

NGROK=$1
case $NGROK in
    localhost) NGROK1=localhost ;;
    *) NGROK1="${NGROK}".ngrok.app ;;
esac

if false ; then

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

helm repo add cnpg https://cloudnative-pg.github.io/charts
helm repo update
helm install cnpg \
  --namespace cnpg-system \
  --create-namespace \
  --wait \
  cnpg/cloudnative-pg

echo -n 'wait for cnpg... '
read y

helm repo add kubewarden https://charts.kubewarden.io
helm repo update

fi

helm install sbomscanner kubewarden/sbomscanner \
  --namespace sbomscanner \
  --create-namespace \
  --wait

# v fails with this error message:

# Error: INSTALLATION FAILED: Cluster.postgresql.cnpg.io
#   "sbomscanner-cnpg-cluster" is invalid: [spec.storage.storageClass:
#   Invalid value: "null": spec.storage.storageClass in body must be of
#   type string: "null", <nil>: Invalid value: null: some validation
#   rules were not checked because the object was invalid; correct the
#   existing errors to complete validation]

# helm install sbomscanner kubewarden/sbomscanner \
#   --namespace sbomscanner \
#   --create-namespace \
#   --set controller.replicas=1 \
#   --set storage.replicas=1 \
#   --set storage.postgres.cnpg.instances=1 \
#   --set worker.replicas=1 \
#   --wait

echo 'run kubectl get pods -n sbomscanner'

kubectl get pods -n sbomscanner

echo -n 'wait for sbom... '
read y

RANCHER_VERSION=2.13.2-alpha3
RANCHER_IMAGE_TAG=v2.13.2-alpha3
CHART_PATH=rancher-alpha/rancher

REPLICA_COUNT=1

helm upgrade --install rancher "${CHART_PATH}" \
  --namespace cattle-system \
  --create-namespace \
  --set rancherImage=rancher/rancher \
  --set rancherImageTag="${RANCHER_IMAGE_TAG}" \
  --set agentTLSMode=system-store \
  --version "${RANCHER_VERSION}" \
  --set tls=external \
  --set replicas=$REPLICA_COUNT \
  --set CATTLE_FEATURES=ui-sql-cache=true \
  --set hostname="$NGROK1"
