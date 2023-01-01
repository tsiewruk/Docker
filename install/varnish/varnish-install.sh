#!/usr/bin/env bash

set -e

source_dir="$(dirname $(readlink -f "$0"))"
source ${source_dir}/../../source/font.sh
ls $source_dir
cp -R "${source_dir/files/service}" /
ls $source_dir
echo-info "Installing Varnish"

apt-get -y update
apt-get -y install -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" varnish