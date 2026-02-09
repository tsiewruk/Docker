#!/bin/bash
#
# Wazuh Dashboard Pre-Init Hook
# Setup and validation before service start
#

set -euo pipefail

log_info "Running Wazuh Dashboard pre-init hook..."

# Check if wazuh-dashboard is installed
check_installation() {
    log_debug "Checking Wazuh Dashboard installation..."

    if [[ ! -d "/usr/share/wazuh-dashboard" ]]; then
        log_error "Wazuh Dashboard not found in /usr/share/wazuh-dashboard"
        return 1
    fi

    log_success "Wazuh Dashboard installation found"
    return 0
}

# Check and create configuration directory
setup_config_dir() {
    log_debug "Setting up configuration directory..."

    if [[ ! -d "/etc/wazuh-dashboard" ]]; then
        log_warning "Configuration directory /etc/wazuh-dashboard not found, creating..."
        mkdir -p /etc/wazuh-dashboard || {
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

    mkdir -p /var/log/wazuh-dashboard || {
        log_error "Failed to create log directory"
        return 1
    }

    # Set ownership if techuser exists
    if id -u techuser &>/dev/null; then
        chown -R techuser:techuser /var/log/wazuh-dashboard || {
            log_warning "Failed to set ownership for log directory"
        }
    fi

    log_success "Log directory ready"
    return 0
}

# Set proper permissions
setup_permissions() {
    log_debug "Setting up permissions..."

    if id -u techuser &>/dev/null; then
        chown -R techuser:techuser /usr/share/wazuh-dashboard 2>/dev/null || {
            log_warning "Failed to set ownership for /usr/share/wazuh-dashboard"
        }

        chown -R techuser:techuser /etc/wazuh-dashboard 2>/dev/null || {
            log_warning "Failed to set ownership for /etc/wazuh-dashboard"
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
setup_permissions || exit 1

log_success "Wazuh Dashboard pre-init hook completed"
