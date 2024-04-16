#!/usr/bin/env bash

set -e

rabbitmqctl import_definitions "/path/to/definitions.file.json"

sed -i "s|a_set_config=1|a_set_config=0|" /etc/scripts.env