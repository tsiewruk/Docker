#!/bin/bash

set -e

. "${TMP_COOKBOOKS_DIR}/source/font.sh"

OPEN_TOFU_VERISON="${1}"

####################################
echo-info "Installing Open TOFU version - ${OPEN_TOFU_VERISON}"
####################################

wget "https://github.com/opentofu/opentofu/releases/download/v${OPEN_TOFU_VERISON}/tofu_${OPEN_TOFU_VERISON}_amd64.deb" -P /tmp/open-tofu
dpkg -i /tmp/open-tofu/tofu_${OPEN_TOFU_VERISON}_amd64.deb

rm -rf /tmp/open-tofu