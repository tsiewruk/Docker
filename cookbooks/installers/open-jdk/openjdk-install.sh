#!/bin/bash

set -e

. "${TMP_COOKBOOKS_DIR}/source/font.sh"

OPEN_JDK_VERSION="${1}"

####################################
echo-info "Installing Open-JDK version - ${OPEN_JDK_VERSION}"
####################################

apt-get -y update
apt-get -y install --no-install-recommends fontconfig openjdk-${OPEN_JDK_VERSION}-jre