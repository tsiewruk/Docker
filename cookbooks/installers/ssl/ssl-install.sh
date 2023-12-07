#!/bin/bash

set -e

. "${TMP_COOKBOOKS_DIR}/source/font.sh"

SSL_VERSION="${1}"

####################################
echo-info "Installing SSL"
####################################

VERSION=$(echo "${SSL_VERSION}" | tr -cd '0-9')
if [ "${VERSION}" -eq "1111" ]; then
    wget http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2_amd64.deb -P /tmp/ssl
    dpkg -i /tmp/ssl/libssl1.1_1.1.1f-1ubuntu2_amd64.deb
else
    echo-error "Instaler is prepared for SSL ver. 1.1.1.1"
fi

rm -rf /tmp/ssl