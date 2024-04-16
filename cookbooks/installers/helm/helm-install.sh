#!/bin/bash

set -e

. "${TMP_COOKBOOKS_DIR}/source/font.sh"

HELM_VERISON="${1}"

####################################
echo-info "Installing HELM version - ${HELM_VERISON}"
####################################

wget "https://get.helm.sh/helm-v${HELM_VERISON}-linux-amd64.tar.gz" -P /tmp/helm
tar -xf "/tmp/helm/helm-v${HELM_VERISON}-linux-amd64.tar.gz" -C /tmp/helm
mv /tmp/helm/linux-amd64/helm /usr/local/bin/

rm -rf /tmp/helm