#!/usr/bin/env bash

set -e

source_dir="$(dirname $(readlink -f "$0"))"
source ${source_dir}/../../../source/font.sh

cp -R "${source_dir/files/service}" /

ZABBIX_VERSION="${1}"
UBUNTU_VERSION="$(lsb_release -r)"

echo-info "Installing Zabbix"

wget "https://repo.zabbix.com/zabbix/${ZABBIX_VERSION}/ubuntu/pool/main/z/zabbix-release/zabbix-release_${ZABBIX_VERSION%2Bubuntu${UBUNTU_VERSION}_all.deb" -P /tmp/zabbix
dpkg -i "/tmp/zabbix/zabbix-release_${ZABBIX_VERSION}+ubuntu${UBUNTU_VERSION}_all.deb"
apt-get -y update
apt-get -y install --no-install-recommends zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-sql-scripts zabbix-agent

rm -rf /tmp/zabbix