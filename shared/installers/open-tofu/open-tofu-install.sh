#!/bin/bash

set -e

. "${TMP_COOKBOOKS_DIR}/source/font.sh"

OPEN_TOFU_VERSION=${1}

####################################
echo-info "Installing Open TOFU version - ${OPEN_TOFU_VERSION}"
####################################

curl --proto '=https' --tlsv1.2 -fsSL https://get.opentofu.org/install-opentofu.sh -o install-opentofu.sh
chmod +x install-opentofu.sh
./install-opentofu.sh --install-method deb --version ${OPEN_TOFU_VERSION}
rm -f install-opentofu.sh

####################################
echo-success "Open TOFU installation completed"
####################################