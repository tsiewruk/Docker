#!/usr/bin/env bash

set -e

source_dir="$(dirname $(readlink -f "$0"))"
source ${source_dir}/../../source/font.sh

cp -R "${SCRIPT_DIR}/files/service" /

echo-info "Installing Openssh-server"
apt-get -y update
apt-get -y install --no-install-recommends openssh-server