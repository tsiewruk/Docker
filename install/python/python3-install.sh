#!/usr/bin/env bash

set -e

source_dir="$(dirname $(readlink -f "$0"))"
source "${source_dir}/../../../source/font.sh"

PYTHON_VERSION="{1}"

echo-info "Installing Python"

add-apt-repository ppa:deadsnakes/ppa
apt-get update -y
apt-get install -y --no-install-recommends "python${PYTHON_VERSION}" "python${PYTHON_VERSION}-pip"