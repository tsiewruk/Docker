#!/bin/bash

set -e

if [ ! -f "/usr/local/bin/entrypoint-scripts.env" ]; then
    touch /usr/local/bin/entrypoint-scripts.env
    echo "export a_configure_grafana=1" >> /usr/local/bin/entrypoint-scripts.env
fi
. /usr/local/bin/entrypoint-scripts.env

env_array=( $(env | sort) )
entrypoint_scripts_path='/usr/local/bin/entrypoint-scripts/'

for var in "${env_array[@]}"; do
    if [ "${var: -1}" = "1" ]; then
        env_name=$(echo ${var:0:-2})
        [ -x "${entrypoint_scripts_path}${env_name}.sh" ] && "${entrypoint_scripts_path}${env_name}.sh"
    fi
done
. /usr/local/bin/entrypoint-scripts.env

exec s6-svscan -t0 /service