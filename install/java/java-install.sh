#!/bin/bash

set -e

source_dir="$(dirname "$0")"
source ${source_dir}/../../source/font.sh

JAVA_VERSION="$1"

echo-info "Installing Java-${JAVA_VERSION}"

apt-get update
apt-get install -y "openjdk-${JAVA_VERSION}-jre"

