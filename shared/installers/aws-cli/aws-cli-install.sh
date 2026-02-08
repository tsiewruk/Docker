#!/bin/bash

set -e

. "${TMP_COOKBOOKS_DIR}/source/font.sh"

####################################
echo-info "Installing AWS-CLI"
####################################

apt-get -y update
apt-get -y install --no-install-recommends awscli

####################################
echo-success "AWS-CLI installation completed"
####################################