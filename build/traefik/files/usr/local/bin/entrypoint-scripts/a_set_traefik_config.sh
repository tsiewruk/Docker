#!/usr/bin/env bash

set -e

sed -i "|<TRAEFIK_CONFIG>|${TRAEFIK_CONFIG}|" /service/traefik/run