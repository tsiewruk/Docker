#!/bin/bash

set -e

. "${TMP_COOKBOOKS_DIR}/source/font.sh"

ANSIBLE_VERISON="${1}"
PYTHON_VERSION="${2}"

"${TMP_FILES_DIR}/install/python/python3-install.sh" "${PYTHON_VERSION}"

####################################
echo-info "Installing Ansible version - ${ANSIBLE_VERISON}"
####################################

pip install ansible=="${ANSIBLE_VERISON}"