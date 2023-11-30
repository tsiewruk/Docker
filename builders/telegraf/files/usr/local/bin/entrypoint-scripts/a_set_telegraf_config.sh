#!/usr/bin/env bash

set -e

INFLUXDB_URL="${1}"
INFLUXDB_USERNAME="${2}"
INFLUXDB_PASSWORD="${3}"

telegraf_config_path=/etc/telegraf.conf
sed -i "s|<INFLUXDB_URL>|$INFLUXDB_URL|g" $telegraf_config_path
sed -i "s|<INFLUXDB_USERNAME>|$INFLUXDB_USERNAME|g" $telegraf_config_path
sed -i "s|<INFLUXDB_PASSWORD>|$INFLUXDB_PASSWORD|g" $telegraf_config_path

sed -i "s|a_set_telegraf_config=1|a_set_telegraf_config=0|" /etc/scripts.env