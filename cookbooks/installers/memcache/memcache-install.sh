#!/bin/bash

set -e

. "${TMP_COOKBOOKS_DIR}/source/font.sh"

source_dir=$(dirname $(readlink -f "$0"))
cp -R "${source_dir}/files/service" /

####################################
echo-info "Installing Memcache"
####################################

apt-get -y update
apt-get -y install --no-install-recommends memcached