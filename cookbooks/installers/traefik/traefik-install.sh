#!/bin/bash

set -e

. "${TMP_COOKBOOKS_DIR}/source/font.sh"

source_dir=$(dirname $(readlink -f "$0"))
cp -R "${source_dir}/files/service" /

TRAEFIK_VERSION="${1}"

####################################
echo-info "Installing Traefik - ${TRAEFIK_VERSION}"
####################################

wget "https://github.com/traefik/traefik/releases/download/v${TRAEFIK_VERSION}/traefik_v${TRAEFIK_VERSION}_linux_amd64.tar.gz" -P /tmp/traefik
tar -xf "/tmp/traefik/traefik_v${TRAEFIK_VERSION}_linux_amd64.tar.gz" -C /usr/local/bin/

rm -rf /tmp/traefik