#!/bin/bash
#
# Service Entrypoint
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
readonly SERVICE_NAME="blackbox"

# No default configuration scripts
readonly DEFAULT_SCRIPTS=()

# ============================================================================
# MAIN ENTRYPOINT
# ============================================================================

main() {
    # Initialize entrypoint framework
    entrypoint_init "\${SERVICE_NAME}" "\${DEFAULT_SCRIPTS[@]}" || {
        log_error "Failed to initialize entrypoint framework"
        exit 1
    }

    # Run main entrypoint flow (hooks only)
    entrypoint_run || {
        log_error "Entrypoint execution failed"
        exit 1
    }

    # Start service supervisor
    entrypoint_start_supervisor s6-svscan -t0 /service
}

# Execute main function
main "\$@"
