FROM ubuntu-base:latest

# ARG from docker-compose
ARG cookbooks_dir
ARG image_builder_dir
ARG MYSQL_EXPORTER_VERSION

# ARG
ARG TMP_COOKBOOKS_DIR='/tmp/cookbook'
ARG TECH_USER_NAME='techuser'
ARG TECH_USER_GROUPS="${TECH_USER_NAME}"

# ENV
ENV MYSQL_EXPORTER_CONFIG_PATH='/etc/mysql-exporter'

# Security: Create specific temp directory with proper permissions
RUN mkdir -p "${TMP_COOKBOOKS_DIR}" && \
    chmod 750 "${TMP_COOKBOOKS_DIR}"

# Copy required files
COPY "${cookbooks_dir}" "${TMP_COOKBOOKS_DIR}"
COPY "${image_builder_dir}/files" /

# Install everything in one optimized layer for smaller image
RUN "${TMP_COOKBOOKS_DIR}/setters/user/add/add-user.sh" "${TECH_USER_NAME}" "${TECH_USER_GROUPS}" && \
    "${TMP_COOKBOOKS_DIR}/installers/prometheus/mysql-exporter/mysql-exporter-install.sh" "${MYSQL_EXPORTER_VERSION}" && \
    "${TMP_COOKBOOKS_DIR}/setters/user/add/configure-user.sh" "/etc/mysql-exporter" "/var/log" "/service" "/usr/local/bin" && \
    "${TMP_COOKBOOKS_DIR}/setters/clean/build-cleanup.sh" && \
    rm -rf "${TMP_COOKBOOKS_DIR}"

# Security: Use non-root user
USER "${TECH_USER_NAME}":"${TECH_USER_NAME}"

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:9104/metrics || exit 1

# Expose port
EXPOSE 9104

ENTRYPOINT ["entrypoint.sh"]