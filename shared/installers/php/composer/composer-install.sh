#!/bin/bash

set -e

. "${TMP_COOKBOOKS_DIR}/source/font.sh"

PHP_COMPOSER_VERSION="${1}"

####################################
echo-info "Installing Composer - ${PHP_COMPOSER_VERSION}"
####################################

curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --version="${PHP_COMPOSER_VERSION}"