#!/usr/bin/env bash

set -e

SCRIPT_DIR=$(dirname $(readlink -f "$0"))

cp -R "${SCRIPT_DIR}/files/service" /

echo-info "Installing Openssh-server"
apt-get -y update
apt-get -y install --no-install-recommends openssh-server