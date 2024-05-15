#!/bin/bash

export CATTLE_AGENT_IMAGE=rancher/rancher-agent:v2.9-head
export CATTLE_DEV_MODE=30
export CATTLE_SYSTEM_CHART_DEFAULT_BRANCH=release-v2.9
export KUBECONFIG=$HOME/.kube/config 
./bin/rancher --add-local=true --no-cacerts --features harvester=false
unset CATTLE_AGENT_IMAGE
unset CATTLE_DEV_MODE
unset CATTLE_SYSTEM_CHART_DEFAULT_BRANCH
unset KUBECONFIG
