#!/bin/bash

set -e

. "${TMP_COOKBOOKS_DIR}/source/font.sh"

OPEN_JDK_VERSION="${1}"

####################################
echo-info "Installing Open-JDK version - ${OPEN_JDK_VERSION}"
####################################

apt-get update -y
apt-get install -y fontconfig openjdk-${OPEN_JDK_VERSION}-jre