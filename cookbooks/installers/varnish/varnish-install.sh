#!/bin/bash

set -e

. "${TMP_COOKBOOKS_DIR}/source/font.sh"

source_dir=$(dirname $(readlink -f "$0"))
cp -R "${source_dir}/files/service" /

####################################
echo-info "Installing Varnish"
####################################

apt-get update -y
apt-get install -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" varnish