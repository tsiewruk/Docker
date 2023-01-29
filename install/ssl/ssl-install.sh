#!/usr/bin/env bash

set -e

source_dir="$(dirname $(readlink -f "$0"))"
source "${source_dir}/../../source/font.sh"

SSL_VEERSION="${1}"

echo-info "Installing SSL"

VERSION=$(echo "${SSL_VEERSION}" | tr -cd '0-9')
if [ "${VERSION}" -eq "1111" ]; then
    wget http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2_amd64.deb -P /tmp/ssl
    dpkg -i /tmp/ssl/libssl1.1_1.1.1f-1ubuntu2_amd64.deb
else
    echo-error "Instaler is prepared for SSL ver. 1.1.1.1"
fi

rm -rf /tmp/ssl