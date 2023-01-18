#!/usr/bin/env bash

set -e

source_dir="$(dirname $(readlink -f "$0"))"
source ${source_dir}/../../source/font.sh

UBUNTU_RELEASE="${1}"

echo-info "Installing SSL"

wget http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.0g-2ubuntu4_amd64.deb -P /tmp/ssl
dpkg -i /tmp/ssl/libssl1.1_1.1.0g-2ubuntu4_amd64.deb

rm -rf /tmp/ssl
