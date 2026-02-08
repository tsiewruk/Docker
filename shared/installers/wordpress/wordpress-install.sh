#!/bin/bash

set -e

. "${TMP_COOKBOOKS_DIR}/source/font.sh"

WORDPRESS_VERSION="${1}"

####################################
echo-info "Installing Wordpress - ${WORDPRESS_VERSION}"
####################################

wget https://pl.wordpress.org/wordpress-${WORDPRESS_VERSION}-pl_PL.tar.gz -P /tmp/wordpress
tar -xvzf /tmp/wordpress/wordpress-${WORDPRESS_VERSION}-pl_PL.tar.gz -C ${APP_PATH}

rm -rf /tmp/wordpress