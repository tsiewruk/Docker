#!/usr/bin/env bash

set -e

MYSQL_VERSION="${1}"

source_dir="$(dirname $(readlink -f "$0"))"
source "${source_dir}/../../../source/font.sh"

cp -R "${source_dir/files/service}" /

echo-info "Installing Mysql"

apt-get -y update
apt-get -y install --no-install-recommends "mysql-server=${MYSQL_VERSION}"