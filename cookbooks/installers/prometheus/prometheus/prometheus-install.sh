#!/bin/bash

set -e

. "${TMP_COOKBOOKS_DIR}/source/font.sh"

source_dir=$(dirname $(readlink -f "$0"))
cp -R "${source_dir}/files/service" /

PROMETHEUS_VERSION="${1}"

####################################
echo-info "Installing Prometheus version - ${PROMETHEUS_VERSION}"
####################################

wget https://github.com/prometheus/prometheus/releases/download/v${PROMETHEUS_VERSION}/prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz -P /tmp/prometheus
tar -xvzf /tmp/prometheus/prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz -C /tmp/prometheus
mkdir -p /etc/prometheus
mv /tmp/prometheus/prometheus-${PROMETHEUS_VERSION}.linux-amd64/* /usr/local/bin/

chown -R ${TECH_USER_NAME}:${TECH_USER_NAME} /usr/local/bin /service /etc/prometheus

rm -rf /tmp/prometheus