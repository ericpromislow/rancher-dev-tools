#!/bin/bash

set -ex

RKE_VERSION="$(grep -m1 'github.com/rancher/rke' go.mod | awk '{print $2}')"
DEFAULT_VALUES="{\"rke-version\":\"${RKE_VERSION}\"}"

GOOS=linux GOARCH=amd64 CGO_ENABLED=0 /usr/lib64/go/1.22/bin/go build -tags k8s \
    -ldflags "-X github.com/rancher/rancher/pkg/version.Version=dev -X github.com/rancher/rancher/pkg/version.GitCommit=dev -X github.com/rancher/rancher/pkg/settings.InjectDefaults=$DEFAULT_VALUES -extldflags -static -s" \
    -o bin/rancher

if [ ! -f bin/data.json ]; then
    curl -sLf https://releases.rancher.com/kontainer-driver-metadata/release-v2.9/data.json > bin/data.json
fi
if [ ! -f bin/k3s-airgap-images.tar ]; then
    touch bin/k3s-airgap-images.tar
fi
