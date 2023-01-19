#!/usr/bin/env bash

set -e

source_dir="$(dirname $(readlink -f "$0"))"
source ${source_dir}/../../source/font.sh

ANSIBLE_VERISON="${1}"

echo-info "Installing Ansible"

apt-get update -y
apt-get install -y --no-install-recommends python3 python3-pip
pip install ansible=="${ANSIBLE_VERISON}"