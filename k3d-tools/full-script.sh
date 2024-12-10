#!/bin/bash

set -exu

D1=$HOME/git/ericpromislow/rancher
D2=$D1/webhook
D3PART=.github/workflows/scripts
D3=$D2/$D3PART

R1=$D1/rancher

#CHART_DIR=$(mktemp -t webhook -d)
#CHART_PATH=$CHART_DIR/rancher.tgz

# trap "echo rm -f $CHART_DIR" 0 1 2 15

cd $R1
#git checkout release/v2.9
#./scripts/chart/build chart
#tar cfz "$CHART_PATH" -C build/chart/rancher .

cd $D2
# make ci

# CLUSTER_NAME=webhook K3S_VERSION=v1.29.5-k3s1 ARCH=arm64 $D3PART/setup-cluster.sh

# k3d image import dist/rancher-webhook-image.tar -c webhook

CHART_PATH=rancher-alpha/rancher VERSION=2.9.0-alpha7 RANCHER_IMAGE_TAG=v2.9.0-rc6 $D3PART/start-rancher.sh
