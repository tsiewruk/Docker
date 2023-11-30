#!/bin/bash

set -e

. "${TMP_COOKBOOKS_DIR}/source/font.sh"

source_dir=$(dirname $(readlink -f "$0"))
cp -R "${source_dir}/files/service" /

####################################
echo-info "Installing Openssh-server"
####################################

apt-get update -y
apt-get install -y --no-install-recommends openssh-server