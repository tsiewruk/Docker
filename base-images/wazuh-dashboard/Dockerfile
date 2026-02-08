FROM ubuntu-base:latest

# ARG from docker-compose
ARG cookbooks_dir
ARG image_builder_dir
ARG WAZUH_DASHBOARD_VERSION

# ARG
ARG TMP_COOKBOOKS_DIR='/tmp/cookbook'
ARG TECH_USER_NAME='techuser'
ARG TECH_USER_GROUPS="${TECH_USER_NAME}"

# Security: Create specific temp directory with proper permissions
RUN mkdir -p "${TMP_COOKBOOKS_DIR}" && \
    chmod 750 "${TMP_COOKBOOKS_DIR}"

# Copy required files
COPY "${cookbooks_dir}" "${TMP_COOKBOOKS_DIR}"
COPY "${image_builder_dir}/files" /

# Install everything in one optimized layer for smaller image
RUN "${TMP_COOKBOOKS_DIR}/setters/user/add/add-user.sh" "${TECH_USER_NAME}" "${TECH_USER_GROUPS}" && \
    "${TMP_COOKBOOKS_DIR}/installers/wazuh/wazuh-dashboard/wazuh-dashboard-install.sh" "${WAZUH_DASHBOARD_VERSION}" && \
    "${TMP_COOKBOOKS_DIR}/setters/clean/build-cleanup.sh" && \
    rm -rf "${TMP_COOKBOOKS_DIR}"

# Security: Use non-root user
USER "${TECH_USER_NAME}":"${TECH_USER_NAME}"

# Health check
HEALTHCHECK --interval=60s --timeout=15s --start-period=120s --retries=5 \
    CMD curl -f http://localhost:5601/api/status || exit 1

# Expose port
EXPOSE 5601

ENTRYPOINT ["entrypoint.sh"]