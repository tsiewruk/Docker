#!/bin/bash

set -e

. "${TMP_COOKBOOKS_DIR}/helpers/view"

SCRIPT_DIR=$(dirname $(readlink -f "$0"))

cp -R "${SCRIPT_DIR}/files/home/root/." /root/
cp "/root/.ssh/id_rsa.pub" "/root/.ssh/authorized_keys"

chmod 755 "/root/.ssh"
chmod 600 "/root/.ssh/id_rsa" "/root/.environment"
chmod 644 "/root/.ssh/id_rsa.pub" "/root/.ssh/authorized_keys" "/root/.ssh/config"