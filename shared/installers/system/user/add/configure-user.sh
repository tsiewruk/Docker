#!/bin/bash

set -e

. "${TMP_COOKBOOKS_DIR}/source/font.sh"

source_dir=$(dirname $(readlink -f "$0"))

####################################
echo-info "Configure ${TECH_USER_NAME} user"
####################################

for service in "${@}"; do
    echo ""${TECH_USER_NAME}" ALL=(ALL) ALL "${service}"" >> "/etc/sudoers.d/${TECH_USER_NAME}"
    chmod -R g+wr "${service}"
    chown -R :"${TECH_USER_NAME}" "${service}"
done