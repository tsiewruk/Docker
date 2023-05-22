#!/usr/bin/env bash

set -e

source_dir="$(dirname $(readlink -f "$0"))"
source "${source_dir}/../../source/font.sh"

echo-info "Installing Supervisor"

apt-get -y update
apt-get -y install --no-install-recommends supervisor

chmod -R 644 /etc/supervisor/conf.d/

ln -s /usr/bin/s6-svc /usr/bin/svc