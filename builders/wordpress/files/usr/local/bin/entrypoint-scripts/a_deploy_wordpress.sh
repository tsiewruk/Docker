#!/bin/bash

set -e

wget https://pl.wordpress.org/wordpress-${WORDPRESS_VERSION}-pl_PL.tar.gz -P /tmp/wordpress
tar -xvzf /tmp/wordpress/wordpress-${WORDPRESS_VERSION}-pl_PL.tar.gz -C ${APP_PATH}

sed -i "s|a_clone_config_script=1|a_deploy_wordpress_script=0|" /etc/scripts.env