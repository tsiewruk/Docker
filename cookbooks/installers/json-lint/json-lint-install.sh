#!/bin/bash

set -e

. "${TMP_COOKBOOKS_DIR}/source/font.sh"

####################################
echo-info "Installing JSON Lint"
####################################

apt-get update -y
apt-get install -y jsonlint