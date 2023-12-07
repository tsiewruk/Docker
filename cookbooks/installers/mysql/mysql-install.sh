#!/bin/bash

set -e

. "${TMP_COOKBOOKS_DIR}/source/font.sh"

source_dir=$(dirname $(readlink -f "$0"))
cp -R "${source_dir}/files/service" /

MYSQL_VERSION="${1}"

####################################
echo-info "Installing Mysql"
####################################

apt-get -y update
apt-get -y install --no-install-recommends "mysql-server=${MYSQL_VERSION}"