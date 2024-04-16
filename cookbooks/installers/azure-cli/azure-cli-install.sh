#!/bin/bash

set -e

. "${TMP_COOKBOOKS_DIR}/source/font.sh"

####################################
echo-info "Installing Azure-CLI"
####################################

curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash