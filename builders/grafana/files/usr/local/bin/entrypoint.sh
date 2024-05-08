#!/bin/bash

set -e

ENV_FILE="/usr/local/bin/entrypoint-scripts.env"
SCRIPTS_PATH="/usr/local/bin/entrypoint-scripts/"

if [ ! -f "${ENV_FILE}" ]; then
    touch "${ENV_FILE}"
    echo "export a_configure_grafana=1" >> "${ENV_FILE}"
fi
source "${ENV_FILE}"

env_array=( $(env | sort) )
for var in "${env_array[@]}"; do
    if [ "${var: -1}" = "1" ]; then
        env_name=$(echo ${var:0:-2})
        [ -x "${SCRIPTS_PATH}${env_name}.sh" ] && "${SCRIPTS_PATH}${env_name}.sh"
    fi
done
source "${ENV_FILE}"

exec s6-svscan -t0 /service