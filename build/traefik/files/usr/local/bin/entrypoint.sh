#!/usr/bin/env bash

set -e

if [ ! -f "/etc/scripts.env" ]; then
    touch /etc/scripts.env
    echo "export a_set_traefik_config=1" >> /etc/scripts.env
fi

source /etc/scripts.env

env_array=( $(env | sort) )
entrypoint_scripts_path='/usr/local/bin/entrypoint-scripts/'

for var in "${env_array[@]}"; do
    if [ "${var: -1}" = "1" ]; then
        env_name=$(echo ${var:0:-2})
        [ -x "${entrypoint_scripts_path}${env_name}.sh" ] && "${entrypoint_scripts_path}${env_name}.sh"
    fi
done

source /etc/scripts.env
exec s6-svscan -t0 /service