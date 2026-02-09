#!/bin/bash
#
# Grafana Pre-Init Hook
# Executed before environment file initialization
# Use this for early checks and setup that must happen before any configuration
#

set -euo pipefail

# Log functions are available from entrypoint-common.sh
log_info "Running Grafana pre-init hook..."

# Example: Check system requirements
check_system_requirements() {
    log_debug "Checking system requirements for Grafana..."

    # Check if required directories exist
    local required_dirs=(
        "/var/lib/grafana"
        "/var/log/grafana"
    )

    for dir in "${required_dirs[@]}"; do
        if [[ ! -d "${dir}" ]]; then
            log_warning "Creating required directory: ${dir}"
            mkdir -p "${dir}" || {
                log_error "Failed to create directory: ${dir}"
                return 1
            }
        fi
    done

    return 0
}

# Example: Set permissions
set_grafana_permissions() {
    log_debug "Setting Grafana permissions..."

    # Set ownership for grafana user (if exists)
    if id -u grafana &>/dev/null; then
        chown -R grafana:grafana /var/lib/grafana 2>/dev/null || true
        chown -R grafana:grafana /var/log/grafana 2>/dev/null || true
        log_debug "Permissions set for grafana user"
    else
        log_debug "Grafana user not found, skipping permission setup"
    fi

    return 0
}

# Execute checks
check_system_requirements || exit 1
set_grafana_permissions || exit 1

log_success "Pre-init hook completed"
