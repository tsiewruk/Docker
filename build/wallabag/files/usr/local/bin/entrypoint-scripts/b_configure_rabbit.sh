#!/usr/bin/env bash

set -e

php bin/console rabbitmq:consumer import_bookmarks --env=prod

sed -i "s|b_configure_rabbit=1|b_configure_rabbit=0|" /etc/scripts.env