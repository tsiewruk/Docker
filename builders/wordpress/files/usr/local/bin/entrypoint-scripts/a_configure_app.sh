#!/bin/bash

set -e

mv ${APP_PATH}/wordpress/wp-config-sample.php ${APP_PATH}/wordpress/wp-config.php
sed -i "s|'database_name_here'|'wordpress'|" ${APP_PATH}/wordpress/wp-config.php
sed -i "s|'username_here'|'${WORDPRESS_DB_USER}'|" ${APP_PATH}/wordpress/wp-config.php
sed -i "s|'password_here'|'${WORDPRESS_DB_PASSWORD}'|" ${APP_PATH}/wordpress/wp-config.php
sed -i "s|'localhost'|'${WORDPRESS_DB_HOST}'|" ${APP_PATH}/wordpress/wp-config.php

sed -i "s|a_configure_app=1|a_configure_app=0|" /etc/entrypoint-scripts.env