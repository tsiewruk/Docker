#!/bin/bash

set -e

. "${TMP_COOKBOOKS_DIR}/source/font.sh"

OPEN_TOFU_VERSION="${1}"

####################################
echo-info "Installing Open TOFU version - ${OPEN_TOFU_VERSION}"
####################################

wget "https://github.com/opentofu/opentofu/releases/download/v${OPEN_TOFU_VERSION}/tofu_${OPEN_TOFU_VERSION}_amd64.deb" -P /tmp/open-tofu
dpkg -i /tmp/open-tofu/tofu_${OPEN_TOFU_VERSION}_amd64.deb

rm -rf /tmp/open-tofu