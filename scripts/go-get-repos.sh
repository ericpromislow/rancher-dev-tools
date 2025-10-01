#!/bin/sh

set -e

mkdir -p ~/workspace/rancher
cd ~/workspace/rancher
git clone git@github.com:rancher/aks-operator.git
cd aks-operator
git pull
cd ..

git clone git@github.com:rancher/apiserver.git
cd apiserver
git pull
cd ..

git clone git@github.com:rancher/backup-restore-operator.git
cd backup-restore-operator
git pull
cd ..

git clone git@github.com:rancher/build-it-charts-build-scripts.git
cd build-it-charts-build-scripts
git pull
cd ..

git clone git@github.com:rancher/charts.git
cd charts
git pull
cd ..

git clone git@github.com:rancher/cli.git
cd cli
git pull
cd ..

git clone git@github.com:rancher/client-go.git
cd client-go
git pull
cd ..

git clone git@github.com:rancher/dashboard.git
cd dashboard
git pull
cd ..

git clone git@github.com:rancher/desktop.git
cd desktop
git pull
cd ..

git clone git@github.com:rancher/docs.git
cd docs
git pull
cd ..

git clone git@github.com:rancher/dynamiclistener.git
cd dynamiclistener
git pull
cd ..

git clone git@github.com:rancher/eks-operator.git
cd eks-operator
git pull
cd ..

git clone git@github.com:rancher/fleet.git
cd fleet
git pull
cd ..

git clone git@github.com:rancher/gke-operator.git
cd gke-operator
git pull
cd ..

git clone git@github.com:rancher/helm.git
cd helm
git pull
cd ..

git clone git@github.com:rancher/helm-locker.git
cd helm-locker
git pull
cd ..

git clone git@github.com:rancher/helm-project-operator.git
cd helm-project-operator
git pull
cd ..

git clone git@github.com:rancher/hull.git
cd hull
git pull
cd ..

git clone git@github.com:rancher/image-mirror.git
cd image-mirror
git pull
cd ..

git clone git@github.com:rancher/kim.git
cd kim
git pull
cd ..

git clone git@github.com:rancher/kontainer-driver-metadata.git
cd kontainer-driver-metadata
git pull
cd ..

git clone git@github.com:rancher/kontainer-engine.git
cd kontainer-engine
git pull
cd ..

git clone git@github.com:rancher/kubectl.git
cd kubectl
git pull
cd ..

git clone git@github.com:rancher/kubernetes-provider-detector.git
cd kubernetes-provider-detector
git pull
cd ..

git clone git@github.com:rancher/lasso.git
cd lasso
git pull
cd ..

git clone git@github.com:rancher/machine.git
cd machine
git pull
cd ..

git clone git@github.com:rancher/norman.git
cd norman
git pull
cd ..

git clone git@github.com:rancher/prometheus-federator.git
cd prometheus-federator
git pull
cd ..

git clone git@github.com:rancher/PushProx.git
cd PushProx
git pull
cd ..

git clone git@github.com:rancher/quickstart.git
cd quickstart
git pull
cd ..

git clone git@github.com:rancher/rancher.git
cd rancher
git pull
cd ..

git clone git@github.com:rancher/rancher-docs.git
cd rancher-docs
git pull
cd ..

git clone git@github.com:rancher/remotedialer.git
cd remotedialer
git pull
cd ..

git clone git@github.com:rancher/remotedialer-proxy.git
cd remotedialer-proxy
git pull
cd ..

git clone git@github.com:rancher/renovate-config.git
cd renovate-config
git pull
cd ..

git clone git@github.com:rancher/rke.git
cd rke
git pull
cd ..

git clone git@github.com:rancher/rke-tools.git
cd rke-tools
git pull
cd ..

git clone git@github.com:rancher/rke2.git
cd rke2
git pull
cd ..

git clone git@github.com:rancher/security-scan.git
cd security-scan
git pull
cd ..

git clone git@github.com:rancher/shell.git
cd shell
git pull
cd ..

git clone git@github.com:rancher/shepherd.git
cd shepherd
git pull
cd ..

git clone git@github.com:rancher/steve.git
cd steve
git pull
cd ..

git clone git@github.com:rancher/system-charts.git
cd system-charts
git pull
cd ..

git clone git@github.com:rancher/system-upgrade-controller.git
cd system-upgrade-controller
git pull
cd ..

git clone git@github.com:rancher/telemetry.git
cd telemetry
git pull
cd ..

git clone git@github.com:rancher/terraform-provider-rancher2.git
cd terraform-provider-rancher2
git pull
cd ..

git clone git@github.com:rancher/ui.git
cd ui
git pull
cd ..

git clone git@github.com:rancher/webhook.git
cd webhook
git pull
cd ..

git clone git@github.com:rancher/wrangler.git
cd wrangler
git pull
cd ..

mkdir -p ~/workspace/rancher
cd ~/workspace/rancher
git clone git@github.com:rancher/apiserver.git
cd apiserver
git pull
fix-repo apiserver
sync-from-upstream
cd ..

git clone git@github.com:rancher/backup-restore-operator.git
cd backup-restore-operator
git pull
fix-repo backup-restore-operator
sync-from-upstream
cd ..

git clone git@github.com:rancher/charts.git
cd charts
git pull
fix-repo charts
sync-from-upstream
cd ..

git clone git@github.com:rancher/dashboard.git
cd dashboard
git pull
fix-repo dashboard
sync-from-upstream
cd ..

git clone git@github.com:rancher/dynamiclistener.git
cd dynamiclistener
git pull
fix-repo dynamiclistener
sync-from-upstream
cd ..

git clone git@github.com:rancher/kubectl.git
cd kubectl
git pull
fix-repo kubectl
sync-from-upstream
cd ..

git clone git@github.com:rancher/lasso.git
cd lasso
git pull
fix-repo lasso
sync-from-upstream
cd ..

git clone git@github.com:rancher/norman.git
cd norman
git pull
fix-repo norman
sync-from-upstream
cd ..

git clone git@github.com:rancher/PushProx.git
cd PushProx
git pull
fix-repo PushProx
sync-from-upstream
cd ..

git clone git@github.com:rancher/rancher.git
cd rancher
git pull
fix-repo rancher
sync-from-upstream
cd ..

git clone git@github.com:rancher/rancher-desktop.git
cd rancher-desktop
git pull
fix-repo rancher-desktop
sync-from-upstream
cd ..

git clone git@github.com:rancher/rancher-dev-tools.git
cd rancher-dev-tools
git pull
fix-repo rancher-dev-tools
sync-from-upstream
cd ..

git clone git@github.com:rancher/rancher-docs.git
cd rancher-docs
git pull
fix-repo rancher-docs
sync-from-upstream
cd ..

git clone git@github.com:rancher/remotedialer.git
cd remotedialer
git pull
fix-repo remotedialer
sync-from-upstream
cd ..

git clone git@github.com:rancher/steve.git
cd steve
git pull
fix-repo steve
sync-from-upstream
cd ..

git clone git@github.com:rancher/webhook.git
cd webhook
git pull
fix-repo webhook
sync-from-upstream
cd ..

git clone git@github.com:rancher/wrangler.git
cd wrangler
git pull
fix-repo wrangler
sync-from-upstream
cd ..

# get these progs:
# git
# vim
