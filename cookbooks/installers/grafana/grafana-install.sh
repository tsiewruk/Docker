#!/bin/bash

set -e

. "${TMP_COOKBOOKS_DIR}/source/font.sh"

source_dir=$(dirname $(readlink -f "$0"))
cp -R "${source_dir}/files/service" /

GRAFANA_VERSION="${1}"

####################################
echo-info "Installing Grafana version - ${GRAFANA_VERSION}"
####################################

apt-get -y update
apt-get -y install --no-install-recommends libfontconfig1 musl
wget https://dl.grafana.com/enterprise/release/grafana-enterprise_${GRAFANA_VERSION}_amd64.deb -P /tmp/grafana
dpkg -i /tmp/grafana/grafana-enterprise_${GRAFANA_VERSION}_amd64.deb

chown -R ${TECH_USER_NAME}:${TECH_USER_NAME} /usr/local/bin /service /usr/share/grafana

rm -rf /tmp/grafana