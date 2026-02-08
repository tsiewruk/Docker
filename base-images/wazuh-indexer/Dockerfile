FROM debian-base:latest

# ARG from docker-compose
ARG cookbooks_dir
ARG image_builder_dir
ARG WAZUH_INDEXER_VERSION

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
RUN "${TMP_COOKBOOKS_DIR}/shared/installers/system/user/add/add-user.sh" "${TECH_USER_NAME}" "${TECH_USER_GROUPS}" && \
    "${TMP_COOKBOOKS_DIR}/shared/installers/wazuh/wazuh-indexer/wazuh-indexer-install.sh" "${WAZUH_INDEXER_VERSION}" && \
    "${TMP_COOKBOOKS_DIR}/shared/installers/system/cleanup/build-cleanup.sh" && \
    rm -rf "${TMP_COOKBOOKS_DIR}"

# Health check
HEALTHCHECK --interval=60s --timeout=15s --start-period=180s --retries=5 \
    CMD curl -f http://localhost:9200/_cluster/health || exit 1

# Expose ports
EXPOSE 9200 9300

ENTRYPOINT ["entrypoint.sh"]