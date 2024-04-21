#!/bin/bash

set -e

. "${TMP_COOKBOOKS_DIR}/source/font.sh"

####################################
echo-info "Installing Docker"
####################################

curl -sSL https://get.docker.com/ | sh