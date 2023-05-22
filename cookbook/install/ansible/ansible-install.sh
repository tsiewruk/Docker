#!/usr/bin/env bash

set -e

source_dir="$(dirname $(readlink -f "$0"))"
source "${source_dir}/../../source/font.sh"

ANSIBLE_VERISON="${1}"
PYTHON_VERSION="${2}"

"${TMP_FILES_DIR}/install/python/python3-install.sh" "${PYTHON_VERSION}"

echo-info "Installing Ansible"

pip install ansible=="${ANSIBLE_VERISON}"