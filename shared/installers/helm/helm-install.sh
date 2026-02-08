#!/bin/bash

set -e

. "${TMP_COOKBOOKS_DIR}/source/font.sh"

HELM_VERISON=${1}

####################################
echo-info "Installing HELM version - ${HELM_VERISON}"
####################################

apt-get -y update
apt-get -y install --no-install-recommends gpg apt-transport-https
curl -fsSL https://packages.buildkite.com/helm-linux/helm-debian/gpgkey | gpg --dearmor | tee /usr/share/keyrings/helm.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/helm.gpg] https://packages.buildkite.com/helm-linux/helm-debian/any/ any main" | tee /etc/apt/sources.list.d/helm-stable-debian.list
apt-get -y update
apt-get -y install --no-install-recommends helm=${HELM_VERISON}

####################################
echo-success "HELM installation completed"
####################################