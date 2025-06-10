#!/bin/bash

set -euo pipefail

# Configuration
ENV_FILE="/usr/local/bin/entrypoint-scripts.env"
SCRIPTS_PATH="/usr/local/bin/entrypoint-scripts/"
LOG_FILE="/var/log/entrypoint.log"

# Logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "${LOG_FILE}"
}

# Error handling
trap 'log "ERROR: Entrypoint failed at line $LINENO"' ERR

log "Starting Grafana entrypoint..."

# Initialize environment file
if [ ! -f "${ENV_FILE}" ]; then
    log "Creating environment file: ${ENV_FILE}"
    touch "${ENV_FILE}"
    echo "export a_configure_grafana=1" >> "${ENV_FILE}"
fi

# Source environment safely
if [ -r "${ENV_FILE}" ]; then
    source "${ENV_FILE}"
else
    log "WARNING: Cannot read environment file: ${ENV_FILE}"
fi

# Execute configuration scripts
log "Processing configuration scripts..."
env_array=( $(env | sort) )
for var in "${env_array[@]}"; do
    if [[ "${var}" =~ ^[a-zA-Z_][a-zA-Z0-9_]*=1$ ]]; then
        env_name=$(echo "${var}" | cut -d'=' -f1)
        script_file="${SCRIPTS_PATH}${env_name}.sh"
        
        if [ -x "${script_file}" ]; then
            log "Executing configuration script: ${script_file}"
            "${script_file}" || {
                log "ERROR: Configuration script failed: ${script_file}"
                exit 1
            }
        fi
    fi
done

# Re-source environment after scripts
if [ -r "${ENV_FILE}" ]; then
    source "${ENV_FILE}"
fi

log "Starting s6 supervision..."
exec s6-svscan -t0 /service