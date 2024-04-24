#!/bin/bash

set -e

. "${TMP_COOKBOOKS_DIR}/source/font.sh"

source_dir=$(dirname $(readlink -f "$0"))

TECH_USER_NAME="${1}"
TECH_USER_GROUPS="${2}"

####################################
echo-info "Add ${TECH_USER_NAME} user"
####################################

groupadd -g 10001 "${TECH_USER_NAME}"
useradd -u 10000 -g "${TECH_USER_GROUPS}" --create-home "${TECH_USER_NAME}" --shell "/bin/bash"

#cp -R "${source_dir}/files/home/techuser/." "/home/${TECH_USER_NAME}/"
#cp "/home/${TECH_USER_NAME}/".ssh/id_rsa.pub "/home/${TECH_USER_NAME}/".ssh/authorized_keys

#chmod 755 "/home/${TECH_USER_NAME}/.ssh"
#chmod 600 "/home/${TECH_USER_NAME}/.ssh/id_rsa" "/home/${TECH_USER_NAME}/.environment"
#chmod 644 "/home/${TECH_USER_NAME}/.ssh/id_rsa.pub" "/home/${TECH_USER_NAME}/.ssh/config" "/home/${TECH_USER_NAME}/.ssh/authorized_keys"

chown -R "${TECH_USER_NAME}":"${TECH_USER_NAME}" "/home/${TECH_USER_NAME}/"