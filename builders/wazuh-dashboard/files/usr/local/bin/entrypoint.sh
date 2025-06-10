#!/bin/bash

set -euo pipefail

# Configuration
LOG_FILE="/var/log/wazuh-dashboard-entrypoint.log"

# Logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "${LOG_FILE}"
}

# Error handling
trap 'log "ERROR: Wazuh Dashboard entrypoint failed at line $LINENO"' ERR

log "Starting Wazuh Dashboard entrypoint..."

# Check if wazuh-dashboard is installed
if [ ! -d "/usr/share/wazuh-dashboard" ]; then
    log "ERROR: Wazuh Dashboard not found in /usr/share/wazuh-dashboard"
    exit 1
fi

# Check configuration directory
if [ ! -d "/etc/wazuh-dashboard" ]; then
    log "WARNING: Configuration directory /etc/wazuh-dashboard not found"
    mkdir -p /etc/wazuh-dashboard
fi

# Create log directory
mkdir -p /var/log/wazuh-dashboard
chown -R techuser:techuser /var/log/wazuh-dashboard

# Set proper permissions
chown -R techuser:techuser /usr/share/wazuh-dashboard
chown -R techuser:techuser /etc/wazuh-dashboard

log "Starting s6 supervision for Wazuh Dashboard..."
exec s6-svscan -t0 /service