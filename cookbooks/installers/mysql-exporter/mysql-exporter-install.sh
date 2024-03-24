#!/bin/bash

set -e

SCRIPT_DIR=$(dirname $(readlink -f "$0"))
cp -R "${SCRIPT_DIR}/files/service" /

. "${TMP_COOKBOOKS_DIR}/helpers/view"

MYSQL_EXPORTER_VERSION="${1}"

####################################
echo-info "Installing MySQL Exporter version - ${MYSQL_EXPORTER_VERSION}"
####################################

wget https://github.com/prometheus/mysqld_exporter/releases/download/v${MYSQL_EXPORTER_VERSION}/mysqld_exporter-${MYSQL_EXPORTER_VERSION}.linux-amd64.tar.gz -P /tmp/mysql-exporter
tar -xvzf /tmp/mysql-exporter/mysqld_exporter-${MYSQL_EXPORTER_VERSION}.linux-amd64.tar.gz -C /tmp/mysql-exporter
mv /tmp/mysql-exporter/mysqld_exporter-${MYSQL_EXPORTER_VERSION}.linux-amd64/mysqld_exporter /usr/local/bin/

rm -rf /tmp/mysql-exporter