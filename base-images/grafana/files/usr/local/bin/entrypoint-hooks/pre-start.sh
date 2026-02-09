#!/bin/bash
#
# Grafana Pre-Start Hook
# Executed after all configuration scripts, before starting supervisor
# Use this for final checks and cleanup before service starts
#

set -euo pipefail

log_info "Running Grafana pre-start hook..."

# Example: Final configuration validation
validate_final_config() {
    log_debug "Performing final Grafana configuration validation..."

    local errors=0

    # Check if Grafana binary exists
    if ! command_exists grafana-server; then
        log_error "Grafana server binary not found"
        errors=$((errors + 1))
    fi

    # Check if config file is valid (example)
    local config_file="/etc/grafana/grafana.ini"
    if [[ -f "${config_file}" ]]; then
        log_debug "Configuration file exists: ${config_file}"
    else
        log_warning "Configuration file not found: ${config_file}"
    fi

    if (( errors > 0 )); then
        log_error "Found ${errors} error(s) in final validation"
        return 1
    fi

    return 0
}

# Example: Health check for dependencies
check_dependencies() {
    log_debug "Checking Grafana dependencies..."

    # Example: Wait for database if configured
    if [[ -n "${GF_DATABASE_HOST:-}" ]]; then
        log_info "Database configured: ${GF_DATABASE_HOST}"
        # Could use wait_for_port function from common library
        # wait_for_port "${GF_DATABASE_HOST}" "${GF_DATABASE_PORT:-3306}" 30
    fi

    return 0
}

# Example: Cleanup temporary files
cleanup_temp_files() {
    log_debug "Cleaning up temporary files..."

    # Clean any temporary files that shouldn't persist
    find /tmp -name "grafana-*" -type f -mtime +1 -delete 2>/dev/null || true

    return 0
}

# Execute pre-start tasks
validate_final_config || exit 1
check_dependencies || exit 1
cleanup_temp_files || exit 1

log_success "Pre-start hook completed - ready to start Grafana"
