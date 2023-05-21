#!/usr/bin/env bash

set -e

source_dir="$(dirname $(readlink -f "$0"))"
source "${source_dir}/../../source/font.sh"

PHP_COMPOSER_VERSION="${1}"

echo-info "Installing Composer"

curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --version="${PHP_COMPOSER_VERSION}"