#!/bin/bash

set -e

sed -i "s|<ALERTMANAGER_URL>|${ALERTMANAGER_URL}|" /service/alert-manager/run 

sed -i "s|a_configure_alert_manager=1|a_configure_alert_manager=0|" /usr/local/bin/entrypoint-scripts.env