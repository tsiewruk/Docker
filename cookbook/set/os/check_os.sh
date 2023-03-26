#!/usr/bin/env bash

set -e

source_dir="$(dirname $(readlink -f "$0"))"
source "${source_dir}/../../source/font.sh"

echo-info "Checking system..."

export "OS=$(lsb_release -is | tr '[:upper:]' '[:lower:]')"
export "RELEASE=$(lsb_release -cs)"