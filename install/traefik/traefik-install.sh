#!/usr/bin/env bash

set -e

source_dir="$(dirname $(readlink -f "$0"))"
source ${source_dir}/../../../source/font.sh

cp -R "${source_dir/files/service}" /

TRAEFIK_VERSION="${1}"

echo-info "Installing Traefik"

wget "https://github.com/traefik/traefik/releases/download/v2.9.6/traefik_v${TRAEFIK_VERSION}_linux_amd64.tar.gz" -P /tmp/traefik
tar -xf "/tmp/traefik/traefik_v${TRAEFIK_VERSION}_linux_amd64.tar.gz" -C /usr/local/bin/ traefik

rm -rf /tmp/traefik
