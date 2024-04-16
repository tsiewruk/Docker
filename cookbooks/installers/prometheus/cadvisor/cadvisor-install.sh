#!/bin/bash

set -e

. "${TMP_COOKBOOKS_DIR}/source/font.sh"

source_dir=$(dirname $(readlink -f "$0"))
cp -R "${source_dir}/files/service" /

CADVISOR_VERSION="${1}"

####################################
echo-info "Installing cAdvisor version - ${CADVISOR_VERSION}"
####################################

wget https://github.com/google/cadvisor/releases/download/v0.47.2/cadvisor-v${CADVISOR_VERSION}-linux-amd64 -P /tmp/cadvisor
chmod +x /tmp/cadvisor/cadvisor-v${CADVISOR_VERSION}-linux-amd64
mv /tmp/cadvisor/cadvisor-v${CADVISOR_VERSION}-linux-amd64 /usr/local/bin/cadvisor

rm -rf /tmp/cadvisor