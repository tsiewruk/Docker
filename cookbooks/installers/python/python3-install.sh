#!/bin/bash

set -e

. "${TMP_COOKBOOKS_DIR}/source/font.sh"

PYTHON_VERSION="${1}"

####################################
echo-info "Installing Python - ${PYTHON_VERSION}"
####################################

apt-get -y update
apt-get -y install --no-install-recommends software-properties-common
add-apt-repository -y ppa:deadsnakes/ppa
apt-get -y update
apt-get -y install "python${PYTHON_VERSION}" "python${PYTHON_VERSION}-distutils" "python$(echo ${PYTHON_VERSION} | awk -F. '{print $1}')-pip"
python3 -m pip install --upgrade pip

update-alternatives --install /usr/bin/python3 python3 "/usr/bin/python${PYTHON_VERSION}" 1