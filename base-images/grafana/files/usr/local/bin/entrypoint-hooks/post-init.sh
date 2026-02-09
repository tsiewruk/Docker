#!/bin/bash
#
# Grafana Post-Init Hook
# Executed after environment file initialization, before configuration scripts
# Use this for setup that depends on environment variables
#

set -euo pipefail

log_info "Running Grafana post-init hook..."

# Example: Validate environment variables
validate_environment() {
    log_debug "Validating Grafana environment variables..."

    # Check for required environment variables (examples)
    local warnings=0

    if [[ -z "${GF_PATHS_DATA:-}" ]]; then
        log_warning "GF_PATHS_DATA not set, using default: /var/lib/grafana"
        warnings=$((warnings + 1))
    fi

    if [[ -z "${GF_PATHS_LOGS:-}" ]]; then
        log_warning "GF_PATHS_LOGS not set, using default: /var/log/grafana"
        warnings=$((warnings + 1))
    fi

    if (( warnings > 0 )); then
        log_info "Found ${warnings} environment variable warning(s)"
    fi

    return 0
}

# Example: Setup default configuration
setup_default_config() {
    log_debug "Setting up Grafana default configuration..."

    # Create default config file if it doesn't exist
    local config_file="/etc/grafana/grafana.ini"

    if [[ ! -f "${config_file}" ]]; then
        log_info "Creating default Grafana configuration: ${config_file}"
        # This would typically copy from a template
        # cp /etc/grafana/grafana.ini.template "${config_file}" || true
    else
        log_debug "Grafana configuration exists: ${config_file}"
    fi

    return 0
}

# Execute setup
validate_environment || exit 1
setup_default_config || exit 1

log_success "Post-init hook completed"
