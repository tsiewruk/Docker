#!/bin/bash

set -e

. "${TMP_COOKBOOKS_DIR}/source/font.sh"

####################################
echo-info "Installing Git"
####################################

apt-get -y update
apt-get -y install --no-install-recommends git