#!/bin/bash

set -euo pipefail

# Configuration
LOG_FILE="/var/log/wazuh-indexer-entrypoint.log"

# Logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "${LOG_FILE}"
}

# Error handling
trap 'log "ERROR: Wazuh Indexer entrypoint failed at line $LINENO"' ERR

log "Starting Wazuh Indexer entrypoint..."

# Check if wazuh-indexer is installed
if [ ! -d "/usr/share/wazuh-indexer" ]; then
    log "ERROR: Wazuh Indexer not found in /usr/share/wazuh-indexer"
    exit 1
fi

# Check configuration directory
if [ ! -d "/etc/wazuh-indexer" ]; then
    log "WARNING: Configuration directory /etc/wazuh-indexer not found"
    mkdir -p /etc/wazuh-indexer
fi

# Create log directory
mkdir -p /var/log/wazuh-indexer
chown -R techuser:techuser /var/log/wazuh-indexer

# Set proper permissions for OpenSearch
chown -R techuser:techuser /usr/share/wazuh-indexer
chown -R techuser:techuser /etc/wazuh-indexer

# Create data directory if it doesn't exist
if [ ! -d "/var/lib/wazuh-indexer" ]; then
    mkdir -p /var/lib/wazuh-indexer
    chown -R techuser:techuser /var/lib/wazuh-indexer
fi

log "Starting s6 supervision for Wazuh Indexer..."
exec s6-svscan -t0 /service