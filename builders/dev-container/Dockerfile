FROM ubuntu-base:latest

# ARG from docker-compose
ARG cookbooks_dir
ARG image_builder_dir
ARG ANSIBLE_VERSION
ARG PYTHON_VERSION
ARG TERRAFORM_VERSION
ARG HELM_VERSION
ARG OPEN_TOFU_VERSION

# ARG 
ARG DEBIAN_FRONTEND='noninteractive'
ARG TMP_COOKBOOKS_DIR='/tmp/cookbook'

# Security: Create specific temp directory with proper permissions
RUN mkdir -p "${TMP_COOKBOOKS_DIR}" && \
    chmod 750 "${TMP_COOKBOOKS_DIR}"

# Copy required files
COPY "${cookbooks_dir}" "${TMP_COOKBOOKS_DIR}"
COPY "${image_builder_dir}/files" /

# Install everything in one optimized layer for smaller image
RUN "${TMP_COOKBOOKS_DIR}/installers/git/git-install.sh" && \
    "${TMP_COOKBOOKS_DIR}/installers/openssh/server/openssh-install.sh" && \
    "${TMP_COOKBOOKS_DIR}/installers/python/python3-install.sh" "${PYTHON_VERSION}" && \
    "${TMP_COOKBOOKS_DIR}/installers/precommit/precommit-install.sh" && \
    "${TMP_COOKBOOKS_DIR}/installers/yaml-lint/yaml-lint-install.sh" && \
    "${TMP_COOKBOOKS_DIR}/installers/json-lint/json-lint-install.sh" && \
    "${TMP_COOKBOOKS_DIR}/installers/ansible/ansible-install.sh" "${ANSIBLE_VERSION}" && \
    "${TMP_COOKBOOKS_DIR}/installers/terraform/terraform-install.sh" "${TERRAFORM_VERSION}" && \
    "${TMP_COOKBOOKS_DIR}/installers/open-tofu/open-tofu-install.sh" "${OPEN_TOFU_VERSION}" && \
    "${TMP_COOKBOOKS_DIR}/installers/azure-cli/azure-cli-install.sh" && \
    "${TMP_COOKBOOKS_DIR}/installers/helm/helm-install.sh" "${HELM_VERSION}" && \
    "${TMP_COOKBOOKS_DIR}/setters/clean/build-cleanup.sh" && \
    rm -rf "${TMP_COOKBOOKS_DIR}"

# Health check for development tools
HEALTHCHECK --interval=60s --timeout=10s --start-period=30s --retries=3 \
    CMD python3 --version && terraform --version && ansible --version || exit 1

# Expose SSH port for development access
EXPOSE 22

ENTRYPOINT ["entrypoint.sh"]
