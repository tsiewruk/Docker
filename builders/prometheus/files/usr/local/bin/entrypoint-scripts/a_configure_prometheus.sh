#!/bin/bash

set -e

sed -i "s|<PROMETHEUS_URL>|${PROMETHEUS_URL}|" /service/prometheus/run 

sed -i "s|a_configure_prometheus=1|a_configure_prometheus=0|" /usr/local/bin/entrypoint-scripts.env