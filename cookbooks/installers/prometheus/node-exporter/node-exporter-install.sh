#!/bin/bash

set -e

. "${TMP_COOKBOOKS_DIR}/source/font.sh"

source_dir=$(dirname $(readlink -f "$0"))
cp -R "${source_dir}/files/service" /

NODE_EXPORTER_VERSION="${1}"

####################################
echo-info "Installing Node-Exporter version - ${NODE_EXPORTER_VERSION}"
####################################

wget https://github.com/prometheus/node_exporter/releases/download/v${NODE_EXPORTER_VERSION}/node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz -P /tmp/node-exporter
tar -xvzf /tmp/node-exporter/node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz -C /tmp/node-exporter
mv /tmp/node-exporter/node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64/node_exporter /usr/local/bin/

rm -rf /tmp/node-exporter