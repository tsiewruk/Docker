#!/usr/bin/env bash

set -ex

sed -i "s|<TRAEFIK_CONFIG>|${TRAEFIK_CONFIG}|" /service/traefik/run

sed -i "s|a_set_traefik_config=1|a_set_traefik_config=0|" /etc/entrypoint-scripts.env