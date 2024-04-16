#!/bin/bash

set -e

. "${TMP_COOKBOOKS_DIR}/source/font.sh"

source_dir=$(dirname $(readlink -f "$0"))
cp -R "${source_dir}/files/service" /

PHP_VERSION="${1}"

####################################
echo-info "Installing PHP version - ${PHP_VERSION}"
####################################

# for versions <= 7.4 and >= 8.0
VERSION=$(echo "${PHP_VERSION}" | tr -cd '0-9')
if [ "${VERSION}" -ge "74" ] || [ "${VERSION}" -le "80" ]; then
    add-apt-repository ppa:ondrej/php
fi

apt-get -y update
apt-get -y install --no-install-recommends "php${PHP_VERSION}" \
                                           "php${PHP_VERSION}-fpm"
update-alternatives --set php "/usr/bin/php${PHP_VERSION}"

# required to start fpm
if [ ! -d "/var/log/php/" ]; then
    mkdir -p /var/log/php/
fi

sed -i "s/<PHP_VERSION>/${PHP_VERSION}/g" "/service/php/run"