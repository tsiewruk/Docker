#!/bin/bash

set -e

. "${TMP_COOKBOOKS_DIR}/source/font.sh"

ANSIBLE_VERISON=${1}

####################################
echo-info "Installing Ansible version - ${ANSIBLE_VERISON}"
####################################

apt-get -y update
apt-get -y install --no-install-recommends ansible=="${ANSIBLE_VERISON}"

####################################
echo-success "Ansible installation completed"
####################################