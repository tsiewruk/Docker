#!/bin/bash
#
# Entrypoint Framework - Common Library
# Version: 1.0.0
#
# Provides shared functionality for all service entrypoints including:
# - Structured logging with levels
# - Error handling and trapping
# - Safe environment variable parsing
# - Hook system for service-specific logic
# - Configuration script execution
# - Security validation and sanitization

# ============================================================================
# CONFIGURATION
# ============================================================================

# Default paths (can be overridden)
: "${ENTRYPOINT_LOG_FILE:=/var/log/entrypoint.log}"
: "${ENTRYPOINT_LOG_LEVEL:=INFO}"  # DEBUG, INFO, WARNING, ERROR
: "${ENTRYPOINT_ENV_FILE:=/usr/local/bin/entrypoint-scripts.env}"
: "${ENTRYPOINT_SCRIPTS_PATH:=/usr/local/bin/entrypoint-scripts}"
: "${ENTRYPOINT_HOOKS_PATH:=/usr/local/bin/entrypoint-hooks}"
: "${ENTRYPOINT_SERVICE_NAME:=unknown}"

# Log levels as integers for comparison
declare -r LOG_LEVEL_DEBUG=0
declare -r LOG_LEVEL_INFO=1
declare -r LOG_LEVEL_WARNING=2
declare -r LOG_LEVEL_ERROR=3

# Color codes for terminal output (optional)
declare -r COLOR_RESET='\033[0m'
declare -r COLOR_RED='\033[0;31m'
declare -r COLOR_YELLOW='\033[0;33m'
declare -r COLOR_GREEN='\033[0;32m'
declare -r COLOR_BLUE='\033[0;34m'
declare -r COLOR_GRAY='\033[0;90m'

# ============================================================================
# INTERNAL VARIABLES
# ============================================================================

_ENTRYPOINT_CURRENT_LOG_LEVEL="${LOG_LEVEL_INFO}"
_ENTRYPOINT_INITIALIZED=0
_ENTRYPOINT_CLEANUP_REGISTERED=0

# ============================================================================
# LOGGING FUNCTIONS
# ============================================================================

# Initialize logging system
_init_logging() {
    # Set numeric log level
    case "${ENTRYPOINT_LOG_LEVEL^^}" in
        DEBUG)   _ENTRYPOINT_CURRENT_LOG_LEVEL=${LOG_LEVEL_DEBUG} ;;
        INFO)    _ENTRYPOINT_CURRENT_LOG_LEVEL=${LOG_LEVEL_INFO} ;;
        WARNING) _ENTRYPOINT_CURRENT_LOG_LEVEL=${LOG_LEVEL_WARNING} ;;
        ERROR)   _ENTRYPOINT_CURRENT_LOG_LEVEL=${LOG_LEVEL_ERROR} ;;
        *)       _ENTRYPOINT_CURRENT_LOG_LEVEL=${LOG_LEVEL_INFO} ;;
    esac

    # Create log directory if needed
    local log_dir
    log_dir="$(dirname "${ENTRYPOINT_LOG_FILE}")"
    if [[ ! -d "${log_dir}" ]]; then
        mkdir -p "${log_dir}" 2>/dev/null || true
    fi

    # Ensure log file is writable
    if [[ -w "${log_dir}" ]]; then
        touch "${ENTRYPOINT_LOG_FILE}" 2>/dev/null || true
    fi
}

# Internal logging function
_log() {
    local level="$1"
    local level_num="$2"
    local color="$3"
    shift 3
    local message="$*"

    # Check if we should log this level
    if (( level_num < _ENTRYPOINT_CURRENT_LOG_LEVEL )); then
        return 0
    fi

    local timestamp
    timestamp="$(date '+%Y-%m-%d %H:%M:%S')"
    local log_line="[${timestamp}] [${ENTRYPOINT_SERVICE_NAME}] [${level}] ${message}"

    # Write to log file
    if [[ -w "${ENTRYPOINT_LOG_FILE}" ]]; then
        echo "${log_line}" >> "${ENTRYPOINT_LOG_FILE}" 2>/dev/null || true
    fi

    # Write to stderr with color if terminal
    if [[ -t 2 ]]; then
        echo -e "${color}[${level}]${COLOR_RESET} ${message}" >&2
    else
        echo "[${level}] ${message}" >&2
    fi
}

# Public logging functions
log_debug() {
    _log "DEBUG" "${LOG_LEVEL_DEBUG}" "${COLOR_GRAY}" "$@"
}

log_info() {
    _log "INFO" "${LOG_LEVEL_INFO}" "${COLOR_BLUE}" "$@"
}

log_success() {
    _log "INFO" "${LOG_LEVEL_INFO}" "${COLOR_GREEN}" "$@"
}

log_warning() {
    _log "WARNING" "${LOG_LEVEL_WARNING}" "${COLOR_YELLOW}" "$@"
}

log_error() {
    _log "ERROR" "${LOG_LEVEL_ERROR}" "${COLOR_RED}" "$@"
}

# ============================================================================
# ERROR HANDLING
# ============================================================================

# Cleanup function called on exit
_cleanup() {
    local exit_code=$?
    if (( exit_code != 0 )); then
        log_error "Entrypoint exited with code ${exit_code}"
    fi
}

# Error trap handler
_error_trap() {
    local line_no="$1"
    local bash_lineno="$2"
    local command="$3"
    log_error "Command failed at line ${line_no}: ${command}"
    log_error "Bash traceback: ${bash_lineno}"
}

# Setup error handling and traps
setup_error_handling() {
    # Enable strict error handling
    set -euo pipefail

    # Set trap for errors
    trap '_error_trap ${LINENO} "${BASH_LINENO[*]}" "$BASH_COMMAND"' ERR

    # Set trap for cleanup on exit
    if (( _ENTRYPOINT_CLEANUP_REGISTERED == 0 )); then
        trap _cleanup EXIT
        _ENTRYPOINT_CLEANUP_REGISTERED=1
    fi

    log_debug "Error handling configured: set -euo pipefail with ERR and EXIT traps"
}

# ============================================================================
# VALIDATION AND SANITIZATION
# ============================================================================

# Validate that a path exists and is within allowed directories
validate_path() {
    local path="$1"
    local must_exist="${2:-true}"

    # Check for path traversal attempts
    if [[ "${path}" =~ \.\. ]]; then
        log_error "Path traversal detected in: ${path}"
        return 1
    fi

    # Check for null bytes
    if [[ "${path}" =~ $'\0' ]]; then
        log_error "Null byte detected in path: ${path}"
        return 1
    fi

    # Check existence if required
    if [[ "${must_exist}" == "true" ]] && [[ ! -e "${path}" ]]; then
        log_error "Path does not exist: ${path}"
        return 1
    fi

    return 0
}

# Validate script file before execution
validate_script() {
    local script_path="$1"

    # Check path is safe
    if ! validate_path "${script_path}" "true"; then
        return 1
    fi

    # Check it's a regular file
    if [[ ! -f "${script_path}" ]]; then
        log_error "Not a regular file: ${script_path}"
        return 1
    fi

    # Check it's executable
    if [[ ! -x "${script_path}" ]]; then
        log_error "Script is not executable: ${script_path}"
        return 1
    fi

    # Check shebang (first line should start with #!)
    local first_line
    first_line="$(head -n1 "${script_path}" 2>/dev/null || echo "")"
    if [[ ! "${first_line}" =~ ^#! ]]; then
        log_warning "Script missing shebang: ${script_path}"
    fi

    return 0
}

# Sanitize variable name (allow only alphanumeric and underscore)
sanitize_var_name() {
    local var_name="$1"
    echo "${var_name}" | sed 's/[^a-zA-Z0-9_]//g'
}

# ============================================================================
# ENVIRONMENT FILE MANAGEMENT
# ============================================================================

# Initialize environment file with default scripts
init_env_file() {
    local default_scripts=("$@")

    if [[ ! -f "${ENTRYPOINT_ENV_FILE}" ]]; then
        log_info "Creating environment file: ${ENTRYPOINT_ENV_FILE}"

        local env_dir
        env_dir="$(dirname "${ENTRYPOINT_ENV_FILE}")"
        mkdir -p "${env_dir}" 2>/dev/null || true

        touch "${ENTRYPOINT_ENV_FILE}" || {
            log_error "Cannot create environment file: ${ENTRYPOINT_ENV_FILE}"
            return 1
        }

        # Add default scripts
        for script in "${default_scripts[@]}"; do
            echo "export ${script}=1" >> "${ENTRYPOINT_ENV_FILE}"
            log_debug "Added default script to env: ${script}"
        done
    fi

    # Source environment file safely
    if [[ -r "${ENTRYPOINT_ENV_FILE}" ]]; then
        # shellcheck disable=SC1090
        source "${ENTRYPOINT_ENV_FILE}" || {
            log_error "Failed to source environment file: ${ENTRYPOINT_ENV_FILE}"
            return 1
        }
        log_debug "Sourced environment file: ${ENTRYPOINT_ENV_FILE}"
    else
        log_error "Cannot read environment file: ${ENTRYPOINT_ENV_FILE}"
        return 1
    fi

    return 0
}

# Source environment file
source_env_file() {
    if [[ -r "${ENTRYPOINT_ENV_FILE}" ]]; then
        # shellcheck disable=SC1090
        source "${ENTRYPOINT_ENV_FILE}" || {
            log_warning "Failed to source environment file: ${ENTRYPOINT_ENV_FILE}"
            return 1
        }
        log_debug "Re-sourced environment file"
    fi
    return 0
}

# ============================================================================
# SCRIPT EXECUTION
# ============================================================================

# Parse environment variables and return script names to execute
# Uses proper regex matching instead of substring checking
get_scripts_to_execute() {
    local -a script_names=()

    # Read environment variables line by line
    while IFS= read -r line; do
        # Match pattern: VARNAME=1 (where VARNAME starts with letter/underscore)
        if [[ "${line}" =~ ^([a-zA-Z_][a-zA-Z0-9_]*)=1$ ]]; then
            local var_name="${BASH_REMATCH[1]}"
            script_names+=("${var_name}")
            log_debug "Found script to execute: ${var_name}"
        fi
    done < <(env | sort)

    # Return script names (newline separated)
    printf '%s\n' "${script_names[@]}"
}

# Execute a configuration script with error handling
execute_script() {
    local script_name="$1"
    local script_path="${ENTRYPOINT_SCRIPTS_PATH}/${script_name}.sh"

    log_info "Executing configuration script: ${script_name}"

    # Validate script before execution
    if ! validate_script "${script_path}"; then
        log_error "Script validation failed: ${script_path}"
        return 1
    fi

    # Execute script and capture output
    local start_time
    start_time="$(date +%s)"

    if "${script_path}"; then
        local end_time
        end_time="$(date +%s)"
        local duration=$((end_time - start_time))
        log_success "Script completed successfully: ${script_name} (${duration}s)"
        return 0
    else
        local exit_code=$?
        log_error "Script failed with exit code ${exit_code}: ${script_name}"
        return "${exit_code}"
    fi
}

# Execute all configuration scripts based on environment variables
execute_config_scripts() {
    local script_count=0
    local failed_count=0

    log_info "Processing configuration scripts from environment variables"

    # Get list of scripts to execute
    local -a scripts
    mapfile -t scripts < <(get_scripts_to_execute)

    if (( ${#scripts[@]} == 0 )); then
        log_info "No configuration scripts to execute"
        return 0
    fi

    log_info "Found ${#scripts[@]} script(s) to execute"

    # Execute each script
    for script_name in "${scripts[@]}"; do
        ((script_count++))

        if ! execute_script "${script_name}"; then
            ((failed_count++))
            log_error "Configuration script failed: ${script_name}"
            # Continue with other scripts or fail fast?
            # For now, fail fast
            return 1
        fi
    done

    if (( failed_count > 0 )); then
        log_error "Configuration failed: ${failed_count}/${script_count} scripts failed"
        return 1
    else
        log_success "All configuration scripts completed: ${script_count}/${script_count} successful"
        return 0
    fi
}

# ============================================================================
# HOOK SYSTEM
# ============================================================================

# Execute a hook if it exists
execute_hook() {
    local hook_name="$1"
    local hook_path="${ENTRYPOINT_HOOKS_PATH}/${hook_name}.sh"

    if [[ ! -f "${hook_path}" ]]; then
        log_debug "Hook not found (skipping): ${hook_name}"
        return 0
    fi

    log_info "Executing hook: ${hook_name}"

    # Validate hook before execution
    if ! validate_script "${hook_path}"; then
        log_warning "Hook validation failed (skipping): ${hook_name}"
        return 0  # Hooks are optional, don't fail
    fi

    # Execute hook
    if "${hook_path}"; then
        log_success "Hook completed: ${hook_name}"
        return 0
    else
        local exit_code=$?
        log_error "Hook failed with exit code ${exit_code}: ${hook_name}"
        return "${exit_code}"
    fi
}

# ============================================================================
# MAIN ENTRYPOINT FLOW
# ============================================================================

# Initialize the entrypoint framework
entrypoint_init() {
    local service_name="$1"
    shift
    local default_scripts=("$@")

    # Set service name
    ENTRYPOINT_SERVICE_NAME="${service_name}"

    # Initialize logging
    _init_logging

    log_info "========================================"
    log_info "Starting entrypoint for: ${ENTRYPOINT_SERVICE_NAME}"
    log_info "========================================"

    # Setup error handling
    setup_error_handling

    # Mark as initialized
    _ENTRYPOINT_INITIALIZED=1

    # Execute pre-init hook
    execute_hook "pre-init" || true

    # Initialize environment file
    if ! init_env_file "${default_scripts[@]}"; then
        log_error "Failed to initialize environment file"
        return 1
    fi

    log_success "Entrypoint framework initialized"
    return 0
}

# Run the main entrypoint flow
entrypoint_run() {
    if (( _ENTRYPOINT_INITIALIZED == 0 )); then
        log_error "Entrypoint not initialized. Call entrypoint_init first."
        return 1
    fi

    # Execute post-init hook
    execute_hook "post-init" || true

    # Execute configuration scripts
    if ! execute_config_scripts; then
        log_error "Configuration scripts failed"
        return 1
    fi

    # Re-source environment file after scripts
    source_env_file

    # Execute pre-start hook
    execute_hook "pre-start" || true

    log_success "Entrypoint configuration completed successfully"
    return 0
}

# Start the service supervisor
entrypoint_start_supervisor() {
    local supervisor_cmd=("$@")

    if (( ${#supervisor_cmd[@]} == 0 )); then
        supervisor_cmd=("s6-svscan" "-t0" "/service")
    fi

    log_info "Starting service supervisor: ${supervisor_cmd[*]}"
    log_info "========================================"

    # Execute the supervisor (replaces current process)
    exec "${supervisor_cmd[@]}"
}

# ============================================================================
# UTILITY FUNCTIONS
# ============================================================================

# Check if running as root
is_root() {
    [[ "$(id -u)" == "0" ]]
}

# Check if a command exists
command_exists() {
    command -v "$1" &>/dev/null
}

# Wait for a file to exist with timeout
wait_for_file() {
    local file_path="$1"
    local timeout="${2:-30}"
    local elapsed=0

    log_info "Waiting for file: ${file_path} (timeout: ${timeout}s)"

    while [[ ! -f "${file_path}" ]] && (( elapsed < timeout )); do
        sleep 1
        ((elapsed++))
    done

    if [[ -f "${file_path}" ]]; then
        log_success "File found: ${file_path}"
        return 0
    else
        log_error "Timeout waiting for file: ${file_path}"
        return 1
    fi
}

# Wait for a TCP port to be open
wait_for_port() {
    local host="$1"
    local port="$2"
    local timeout="${3:-30}"
    local elapsed=0

    log_info "Waiting for ${host}:${port} (timeout: ${timeout}s)"

    while ! timeout 1 bash -c "cat < /dev/null > /dev/tcp/${host}/${port}" 2>/dev/null && (( elapsed < timeout )); do
        sleep 1
        ((elapsed++))
    done

    if (( elapsed < timeout )); then
        log_success "Port is open: ${host}:${port}"
        return 0
    else
        log_error "Timeout waiting for port: ${host}:${port}"
        return 1
    fi
}

# ============================================================================
# EXPORTS
# ============================================================================

# Export public functions
export -f log_debug log_info log_success log_warning log_error
export -f setup_error_handling
export -f validate_path validate_script sanitize_var_name
export -f init_env_file source_env_file
export -f execute_script execute_config_scripts
export -f execute_hook
export -f entrypoint_init entrypoint_run entrypoint_start_supervisor
export -f is_root command_exists wait_for_file wait_for_port
