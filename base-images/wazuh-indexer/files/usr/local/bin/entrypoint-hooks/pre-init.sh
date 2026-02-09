#!/bin/bash
#
# Wazuh Indexer Pre-Init Hook
# Setup and validation before service start
#

set -euo pipefail

log_info "Running Wazuh Indexer pre-init hook..."

# Check if wazuh-indexer is installed
check_installation() {
    log_debug "Checking Wazuh Indexer installation..."

    if [[ ! -d "/usr/share/wazuh-indexer" ]]; then
        log_error "Wazuh Indexer not found in /usr/share/wazuh-indexer"
        return 1
    fi

    log_success "Wazuh Indexer installation found"
    return 0
}

# Check and create configuration directory
setup_config_dir() {
    log_debug "Setting up configuration directory..."

    if [[ ! -d "/etc/wazuh-indexer" ]]; then
        log_warning "Configuration directory /etc/wazuh-indexer not found, creating..."
        mkdir -p /etc/wazuh-indexer || {
            log_error "Failed to create configuration directory"
            return 1
        }
    fi

    log_success "Configuration directory ready"
    return 0
}

# Create and setup log directory
setup_log_dir() {
    log_debug "Setting up log directory..."

    mkdir -p /var/log/wazuh-indexer || {
        log_error "Failed to create log directory"
        return 1
    }

    # Set ownership if techuser exists
    if id -u techuser &>/dev/null; then
        chown -R techuser:techuser /var/log/wazuh-indexer || {
            log_warning "Failed to set ownership for log directory"
        }
    fi

    log_success "Log directory ready"
    return 0
}

# Create and setup data directory
setup_data_dir() {
    log_debug "Setting up data directory..."

    if [[ ! -d "/var/lib/wazuh-indexer" ]]; then
        log_info "Creating data directory: /var/lib/wazuh-indexer"
        mkdir -p /var/lib/wazuh-indexer || {
            log_error "Failed to create data directory"
            return 1
        }

        # Set ownership if techuser exists
        if id -u techuser &>/dev/null; then
            chown -R techuser:techuser /var/lib/wazuh-indexer || {
                log_warning "Failed to set ownership for data directory"
            }
        fi
    fi

    log_success "Data directory ready"
    return 0
}

# Set proper permissions
setup_permissions() {
    log_debug "Setting up permissions for OpenSearch..."

    if id -u techuser &>/dev/null; then
        chown -R techuser:techuser /usr/share/wazuh-indexer 2>/dev/null || {
            log_warning "Failed to set ownership for /usr/share/wazuh-indexer"
        }

        chown -R techuser:techuser /etc/wazuh-indexer 2>/dev/null || {
            log_warning "Failed to set ownership for /etc/wazuh-indexer"
        }

        log_success "Permissions set for techuser"
    else
        log_debug "User techuser not found, skipping permission setup"
    fi

    return 0
}

# Execute setup
check_installation || exit 1
setup_config_dir || exit 1
setup_log_dir || exit 1
setup_data_dir || exit 1
setup_permissions || exit 1

log_success "Wazuh Indexer pre-init hook completed"
