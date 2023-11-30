#!/bin/bash

set -e

git clone <REPOSITORY_LINK> /etc/varnish

sed -i "s|a_clone_config_script=1|a_clone_config_script=0|" /etc/scripts.env