#!/bin/bash
#
# Grafana Service Entrypoint
# Uses the common entrypoint framework
#

# Load common entrypoint library
# shellcheck disable=SC1091
source /usr/local/lib/entrypoint-common.sh || {
    echo "ERROR: Failed to load entrypoint-common.sh" >&2
    exit 1
}

# ============================================================================
# SERVICE CONFIGURATION
# ============================================================================

# Service identification
readonly SERVICE_NAME="grafana"

# Default configuration scripts to run
# These are executed in the order they appear if their env var is set to 1
readonly DEFAULT_SCRIPTS=(
    "a_configure_grafana"
)

# ============================================================================
# SERVICE-SPECIFIC FUNCTIONS (optional)
# ============================================================================

# Add any Grafana-specific functions here if needed
# These can be called from hooks or can be used to extend functionality

grafana_check_config() {
    log_debug "Checking Grafana configuration..."

    if [[ ! -d "/etc/grafana" ]]; then
        log_warning "Grafana config directory not found, creating: /etc/grafana"
        mkdir -p /etc/grafana
    fi

    return 0
}

# ============================================================================
# MAIN ENTRYPOINT
# ============================================================================

main() {
    # Initialize entrypoint framework
    entrypoint_init "${SERVICE_NAME}" "${DEFAULT_SCRIPTS[@]}" || {
        log_error "Failed to initialize entrypoint framework"
        exit 1
    }

    # Run service-specific checks
    grafana_check_config || {
        log_error "Grafana configuration check failed"
        exit 1
    }

    # Run main entrypoint flow (hooks + config scripts)
    entrypoint_run || {
        log_error "Entrypoint execution failed"
        exit 1
    }

    # Start service supervisor
    entrypoint_start_supervisor s6-svscan -t0 /service
}

# Execute main function
main "$@"
