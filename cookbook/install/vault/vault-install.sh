#!/usr/bin/env bash

set -e

source_dir="$(dirname $(readlink -f "$0"))"
source "${source_dir}/../../source/font.sh"

cp -R "${source_dir}/files/service" /

echo-info "Installing Vault"

apt-get update -y
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg >/dev/null
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
apt update -y
apt-get install -y vault