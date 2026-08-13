#!/bin/bash

set -exu

if true ; then

kubectl apply -f https://raw.githubusercontent.com/rancher/local-path-provisioner/master/deploy/local-path-storage.yaml
kubectl annotate sc local-path storageclass.kubernetes.io/is-default-class="true" --overwrite
kubectl get sc   # should show local-path as the default

helm repo add cnpg https://cloudnative-pg.github.io/charts
helm repo update
helm upgrade --install cnpg \
  --namespace cnpg-system \
  --create-namespace \
  --wait \
  cnpg/cloudnative-pg

kubectl rollout status --namespace cnpg-system deploy/cnpg-cloudnative-pg --timeout 10m

helm upgrade --install rancher-sbomscanner kubewarden/sbomscanner \
  --namespace cattle-sbomscanner-system \
  --create-namespace \
  --set controller.image.tag=latest
  --devel \
  --wait

fi

# Step 2....


# kubectl get pods -n rancher-sbomscanner

cd $HOME/lab/rancher/bugs/53988-sbomscanner-problems

kubectl apply -f registry.yaml
kubectl apply -f scanjob.yaml

kubectl get vulnerabilityreport -n default

kubectl get vulnerabilityreport --field-selector='imageMetadata.repository=kubewarden/sbomscanner/test-assets/golang,imageMetadata.platform=linux/amd64'




