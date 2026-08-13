#!/bin/bash

set -exu

# Docker build command:

# export BUILD_SAFE_DIRS=/Users/ericp/git/ericpromislow/rancher
# export BUILD_SAFE_DIRS=/Users/ericp/workspace/rancher
# ARCH=arm64 REPO=morspin TAG=v2.14.2-dev-vai-arm64.$X
# AGENT_ARCH=amd64 AGENT_TAG=v2.14.2-dev-vai-amd64.$X \
# make quick


# ARCH=arm64 REPO=morspin TAG=v2.14.2-dev-vai-arm64.$X make quick

# OR

# export BUILD_SAFE_DIRS=/Users/ericp/git/ericpromislow/rancher
# ARCH=arm64 REPO=morspin TAG=v2.12.0-dev-vai-arm64.$X AGENT_ARCH=amd64 AGENT_TAG=v2.12.0-dev-vai-amd64.$X make quick-server
# ARCH=arm64 REPO=morspin TAG=v2.12.0-dev-vai-arm64.$X AGENT_ARCH=amd64 AGENT_TAG=v2.12.0-dev-vai-amd64.$X make quick-server
# ARCH=arm64 REPO=morspin TAG=v2.12.0-dev-vai-arm64.$X make quick-server && echo $X
# ARCH=arm64 REPO=morspin TAG=v2.12.0-dev-vai-arm64.$X make quick && echo $X
# ARCH=arm64 REPO=morspin TAG=v2.13.0-dev-vai-arm64.$X make quick-server && echo $X

# 

# In a terminal run `ngrok http --inspect=false https://localhost:7443`

# Testing:
# Login to rancher dashboard, create an api key
# Update ~/git/ericpromislow/rancher/rancher/steveapi.yaml
# Run CATTLE_TEST_CONFIG=$PWD/steveapi.yaml go test -count=1 -v \
#     ./tests/v2/integration/steveapi/ -run TestSteveLocal
#
# CATTLE_TEST_CONFIG=$PWD/steveapi.yaml go test -count=1 -v ./tests/v2/integration/steveapi/ -run TestSteveLocal

if [ -n "${1:-}" ] ; then
    IMAGE="$1"
else
    X=158
    I="v2.14.2-dev-vai-arm64.${X}"
    IMAGE="${1:-morspin/rancher:${I}}"
fi

RTAG=$$

# endpoint:
# eric.rancher.tomlebreux.com

# docker run -d --restart=no -p 8080:80 -p 7443:443 --privileged \
# Not with pangolin ^
docker run -d --restart=no -p 8080:80 -p 7443:443 --privileged \
    --name "rancher-$RTAG" \
    -e CATTLE_BOOTSTRAP_PASSWORD='HMAqst069.)$x' \
    -e CATTLE_DEBUG=true \
    -e CATTLE_AGENT_TLS_MODE=system-store \
    -e CATTLE_FEATURES=ui-sql-cache=true \
    $IMAGE --no-cacerts


# TOKEN=ext/token-pzh9j:mnppdfzc5h5lqvwx5xhrpmt52274qtjjjs5vkh4khxls2k88lfpwmh
