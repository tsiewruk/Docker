#!/bin/bash

set -e

. "${TMP_COOKBOOKS_DIR}/source/font.sh"

####################################
echo-info "Installing Precommit version"
####################################

pip install pre-commit