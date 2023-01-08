#!/usr/bin/env bash

set -e

source_dir="$(dirname $(readlink -f "$0"))"
source ${source_dir}/../../source/font.sh

cp -R "${source_dir/files/service}" /

echo-info "Installing Varnish"

apt-get -y update
apt-get -y install -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" varnish