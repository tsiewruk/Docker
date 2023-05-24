#!/usr/bin/env bash

set -e

if [ ! -d "${APP_DEPLOY_PATH}/.git" ]; then
    install -d -o www-data -g www-data -m 755 "${APP_DEPLOY_PATH}"
    sudo -u www-data -g www-data -H git clone https://github.com/wallabag/wallabag.git "${APP_DEPLOY_PATH}"
    git config --global --add safe.directory /srv/http/wallabag
    cd "${APP_DEPLOY_PATH}"
    sudo -u www-data -g www-data -H make install
fi

sed -i "s|a_deploy_app=1|a_deploy_app=0|" /etc/scripts.env