#!/usr/bin/env bash

set -e

sed -i "s|rabbitmq_host: localhost|rabbitmq_host: rabbitmq|" /srv/http/wallabag/app/config/parameters.yml
sed -i "s|rabbitmq_user: guest|rabbitmq_user: rabbitmq|" /srv/http/wallabag/app/config/parameters.yml
sed -i "s|rabbitmq_password: guest|rabbitmq_password: rabbitmq|" /srv/http/wallabag/app/config/parameters.yml

sed -i "s|b_configure_rabbit=1|b_configure_rabbit=0|" /etc/scripts.env