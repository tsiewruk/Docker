#!/bin/bash

set -e

. "${TMP_COOKBOOKS_DIR}/source/font.sh"

PHP_VERSION="${1}"

####################################
echo-info "Installing PHP-Pear"
####################################

wget http://pear.php.net/go-pear.phar
"php${PHP_VERSION}" go-pear.phar
pecl channel-update pecl.php.net