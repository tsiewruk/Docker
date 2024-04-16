#!/bin/bash

set -e

. "${TMP_COOKBOOKS_DIR}/source/font.sh"

source_dir=$(dirname $(readlink -f "$0"))
cp -R "${source_dir}/files/service" /

GRAFANA_VERSION="${1}"

####################################
echo-info "Installing Grafana version - ${GRAFANA_VERSION}"
####################################

apt-get update -y
apt-get install -y --no-install-recommends libfontconfig1 musl
wget https://dl.grafana.com/enterprise/release/grafana-enterprise_${GRAFANA_VERSION}_amd64.deb -P /tmp/grafana
dpkg -i /tmp/grafana/grafana-enterprise_${GRAFANA_VERSION}_amd64.deb

rm -rf /tmp/grafana