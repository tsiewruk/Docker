#!/bin/bash

set -e

. "${TMP_COOKBOOKS_DIR}/source/font.sh"

source_dir=$(dirname $(readlink -f "$0"))

####################################
echo-info "Configure root user"
####################################

#cp -R "${source_dir}/files/home/root/." /root/
#cp "/root/.ssh/id_rsa.pub" "/root/.ssh/authorized_keys"

#chmod 755 "/root/.ssh"
#chmod 600 "/root/.ssh/id_rsa" "/root/.environment"
#chmod 644 "/root/.ssh/id_rsa.pub" "/root/.ssh/authorized_keys" "/root/.ssh/config"
