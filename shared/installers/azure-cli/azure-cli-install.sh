#!/bin/bash

set -e

. "${TMP_COOKBOOKS_DIR}/source/font.sh"

####################################
echo-info "Installing Azure-CLI"
####################################

apt-get -y update
apt-get -y install --no-install-recommends azure-cli

####################################
echo-success "Azure-CLI installation completed"
####################################
