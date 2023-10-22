#!/usr/bin/env bash

set -e

source_dir="$(dirname $(readlink -f "$0"))"
source "${source_dir}/../../source/font.sh"

echo-info "Installing Azure-CLI"

curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash