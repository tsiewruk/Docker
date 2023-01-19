#!/usr/bin/env bash

set -e

source_dir="$(dirname $(readlink -f "$0"))"
source ${source_dir}/../../source/font.sh

echo-info "Installing NGINX"

"${source_dir}/../../set/os/check_os.sh" "${CHECK_OS}" "${CHECK_RELEASE}"

apt-get update
apt-get install -y nginx