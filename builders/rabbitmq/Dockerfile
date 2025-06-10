FROM ubuntu-base:latest

# ARG from docker-compose
ARG cookbooks_dir
ARG image_builder_dir
ARG ERLANG_VERSION
ARG RABBITMQ_VERSION

# ARG
ARG DEBIAN_FRONTEND='noninteractive'
ARG TMP_COOKBOOKS_DIR='/tmp/cookbook'
ARG SSL_VERSION='1.1.1.1'
ARG TECH_USER_NAME='techuser'
ARG TECH_USER_GROUPS="${TECH_USER_NAME}"

# ENV
ENV UBUNTU_RELEASE='focal'

# Security: Create specific temp directory with proper permissions
RUN mkdir -p "${TMP_COOKBOOKS_DIR}" && \
    chmod 750 "${TMP_COOKBOOKS_DIR}"

# Copy required files
COPY "${cookbooks_dir}" "${TMP_COOKBOOKS_DIR}"
COPY "${image_builder_dir}/files" /

# Install everything in one optimized layer for smaller image
RUN apt-get -y update && \
    apt-get -y install --no-install-recommends dpkg-dev && \
    "${TMP_COOKBOOKS_DIR}/setters/user/add/add-user.sh" "${TECH_USER_NAME}" "${TECH_USER_GROUPS}" && \
    "${TMP_COOKBOOKS_DIR}/installers/ssl/ssl-install.sh" "${SSL_VERSION}" && \
    "${TMP_COOKBOOKS_DIR}/installers/erlang/erlang-install.sh" "${UBUNTU_RELEASE}" && \
    "${TMP_COOKBOOKS_DIR}/installers/rabbitmq/rabbitmq-install.sh" "${UBUNTU_RELEASE}" && \
    "${TMP_COOKBOOKS_DIR}/setters/user/add/configure-user.sh" "/etc/rabbitmq" "/var/log" "/service" "/usr/local/bin" && \
    "${TMP_COOKBOOKS_DIR}/setters/clean/build-cleanup.sh" && \
    rm -rf "${TMP_COOKBOOKS_DIR}"

# Security: Use non-root user
USER "${TECH_USER_NAME}":"${TECH_USER_NAME}"

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=5 \
    CMD rabbitmq-diagnostics -q ping || exit 1

# Expose ports
EXPOSE 5672 15672 25672

ENTRYPOINT ["entrypoint.sh"]