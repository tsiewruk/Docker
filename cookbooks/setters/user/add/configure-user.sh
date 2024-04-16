#!/bin/bash

set -e

. "${TMP_COOKBOOKS_DIR}/source/font.sh"

source_dir=$(dirname $(readlink -f "$0"))

USER_NAME="${1}"

####################################
echo-info "Configure ${USER_NAME} user"
####################################

groupadd -g 10001 "${USER_NAME}"
useradd -u 10000 -g "${USER_NAME}" --create-home "${USER_NAME}" --shell "/bin/bash"

#cp -R "${source_dir}/files/home/techuser/." "/home/${USER_NAME}/"
#cp "/home/${USER_NAME}/".ssh/id_rsa.pub "/home/${USER_NAME}/".ssh/authorized_keys

#chmod 755 "/home/${USER_NAME}/.ssh"
#chmod 600 "/home/${USER_NAME}/.ssh/id_rsa" "/home/${USER_NAME}/.environment"
#chmod 644 "/home/${USER_NAME}/.ssh/id_rsa.pub" "/home/${USER_NAME}/.ssh/config" "/home/${USER_NAME}/.ssh/authorized_keys"

chown -R "${USER_NAME}":"${USER_NAME}" "/home/${USER_NAME}/"