#!/usr/bin/env bash

set -e

sed -i "s|rabbitmq_host: localhost|rabbitmq_host: rabbitmq|" /srv/http/wallabag/app/config/parameters.yml.dist
sed -i "s|rabbitmq_user: guest|rabbitmq_user: rabbitmq|" /srv/http/wallabag/app/config/parameters.yml.dist
sed -i "s|rabbitmq_password: guest|rabbitmq_password: rabbitmq|" /srv/http/wallabag/app/config/parameters.yml.dist

sed -i "s|database_port: ~|database_port: 3306|" /srv/http/wallabag/app/config/parameters.yml.dist
sed -i "s|database_user: root|database_user: wallabag|" /srv/http/wallabag/app/config/parameters.yml.dist
sed -i "s|database_password: ~|database_password: wallabag|" /srv/http/wallabag/app/config/parameters.yml.dist
sed -i "s|database_host: 127.0.0.1|database_host: db|" /srv/http/wallabag/app/config/parameters.yml.dist


sed -i "s|b_configure_app=1|b_configure_app=0|" /etc/scripts.env