#!/bin/bash

set -e

. "${TMP_COOKBOOKS_DIR}/source/font.sh"

####################################
echo-info "Cleaning"
####################################

apt-get autoremove -y
apt-get clean
apt-get -y purge dpkg-dev

rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*