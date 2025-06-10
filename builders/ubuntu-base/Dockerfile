FROM ubuntu:24.04

# ARG from docker-compose
ARG cookbooks_dir
ARG image_builder_dir

# ARG
ARG DEBIAN_FRONTEND='noninteractive'
ARG TMP_COOKBOOKS_DIR='/tmp/cookbook'
ARG TZ='Europe/Warsaw'

# Security: Create specific temp directory with proper permissions
RUN mkdir -p "${TMP_COOKBOOKS_DIR}" && \
    chmod 750 "${TMP_COOKBOOKS_DIR}"

# Copy required files
COPY "${cookbooks_dir}" "${TMP_COOKBOOKS_DIR}"
COPY "${image_builder_dir}/files" /

# Install everything in one optimized layer
RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get -y install --no-install-recommends \
        less vim tzdata \
        ca-certificates gnupg \
        s6 sudo htop locales logrotate \
        bash-completion dialog procps \
        rsync telnet net-tools iputils-ping curl wget zip \
        apt-utils apt-transport-https lsb-release software-properties-common && \
    # Set timezone
    "${TMP_COOKBOOKS_DIR}/setters/timezone/timezone-set.sh" "${TZ}" && \
    # Set locales
    locale-gen en_US.UTF-8 pl_PL.UTF-8 && \
    # Clean up everything in one layer
    rm -rf "${TMP_COOKBOOKS_DIR}"

# Health check for base functionality
HEALTHCHECK --interval=30s --timeout=10s --start-period=10s --retries=3 \
    CMD test -f /etc/os-release || exit 1