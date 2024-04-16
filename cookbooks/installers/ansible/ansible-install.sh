#!/bin/bash

set -e

. "${TMP_COOKBOOKS_DIR}/source/font.sh"

ANSIBLE_VERISON="${1}"

####################################
echo-info "Installing Ansible version - ${ANSIBLE_VERISON}"
####################################

pip install ansible=="${ANSIBLE_VERISON}"