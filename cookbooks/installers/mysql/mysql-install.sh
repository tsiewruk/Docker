#!/bin/bash

set -e

. "${TMP_COOKBOOKS_DIR}/source/font.sh"

source_dir=$(dirname $(readlink -f "$0"))
cp -R "${source_dir}/files/service" /

MYSQL_VERSION="${1}"
MYSQL_ROOT_PASS="${2}"

sed -i "s|exit 101|exit 0|" /usr/sbin/policy-rc.d

####################################
echo-info "Installing Mysql version - ${MYSQL_VERSION}"
####################################
wget https://dev.mysql.com/get/mysql-apt-config_0.${MYSQL_VERSION}_all.deb -P /tmp/mysql
dpkg -i /tmp/mysql/mysql-apt-config_0.${MYSQL_VERSION}_all.deb
apt-get -y update
apt-get -y install --no-install-recommends mysql-server mysql-community-server 

mysqladmin -u root password "${MYSQL_ROOT_PASS}"


debconf-set-selections <<< "mysql-community-server  mysql-community-server/re-root-pass password ${MYSQL_ROOT_PASS}"
debconf-set-selections <<< "mysql-community-server  mysql-community-server/root-pass password ${MYSQL_ROOT_PASS}"
