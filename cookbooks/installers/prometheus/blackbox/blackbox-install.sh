#!/bin/bash

set -e

. "${TMP_COOKBOOKS_DIR}/source/font.sh"

source_dir=$(dirname $(readlink -f "$0"))
cp -R "${source_dir}/files/service" /

BLACKBOX_VERSION="${1}"

####################################
echo-info "Installing Blackbox version - ${BLACKBOX_VERSION}"
####################################

wget https://github.com/prometheus/blackbox_exporter/releases/download/v${BLACKBOX_VERSION}/blackbox_exporter-${BLACKBOX_VERSION}.linux-amd64.tar.gz -P /tmp/blackbox
tar -xvzf /tmp/blackbox/blackbox_exporter-${BLACKBOX_VERSION}.linux-amd64.tar.gz -C /tmp/blackbox
mv /tmp/blackbox/blackbox_exporter-${BLACKBOX_VERSION}.linux-amd64/blackbox_exporter /usr/local/bin/

rm -rf /tmp/blackbox