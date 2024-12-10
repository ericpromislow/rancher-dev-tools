#!/bin/bash

set -exu

HOOKDIR=/home/ericp/git/ericpromislow/rancher/webhook
WORKFLOWDIR=$HOOKDIR/.github/workflows
SCRIPTDIR=$WORKFLOWDIR/scripts

cd $HOOKDIR

export CLUSTER_NAME=spiff
export K3S_VERSION="${K3S_VERSION:-v1.28.9-k3s1}"
export ARCH=amd64
export ARCH=arm64
export CHART_PATH=$HOME/trash/rancher.tgz
export RANCHER_IMAGE_TAG=v2.9-head
export VERSION=2.9

test -f $HOOKDIR/dist/rancher-webhook-image.tar

test -n "$(k3d registry list --no-headers)" && $HOME/bin/delete-k3d-cluster

$SCRIPTDIR/setup-cluster.sh

k3d image import $HOOKDIR/dist/rancher-webhook-image.tar -c $CLUSTER_NAME

install-rancher $1
