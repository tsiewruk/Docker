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
ARG DEBIAN_FRONTEND='noineractive'
ARG TMP_FILES_DIR='/tmp/cookbook/'

# required files
COPY "${cookbooks_dir}" "${TMP_COOKBOOKS_DIR}"
COPY "${image_builder_dir}/files" /

# additional requirements
RUN chmod 777 /tmp
# install git
RUN "${TMP_COOKBOOKS_DIR}/installers/git/git-install.sh"
# install openssh-server
RUN "${TMP_COOKBOOKS_DIR}/installers/openssh/server/openssh-install.sh"
# install python
RUN "${TMP_COOKBOOKS_DIR}/installers/python/python3-install.sh" "${PYTHON_VERSION}"
# install precommit
RUN "${TMP_COOKBOOKS_DIR}/installers/precommit/precommit-install.sh"
# install yaml lint
RUN "${TMP_COOKBOOKS_DIR}/installers/yaml-lint/yaml-lint-install.sh"
# install json lint
RUN "${TMP_COOKBOOKS_DIR}/installers/json-lint/json-lint-install.sh"
# install ansible
RUN "${TMP_COOKBOOKS_DIR}/installers/ansible/ansible-install.sh" "${ANSIBLE_VERSION}"
# install terraform
RUN "${TMP_COOKBOOKS_DIR}/installers/terraform/terraform-install.sh" "${TERRAFORM_VERSION}"
# install open-tofu
RUN "${TMP_COOKBOOKS_DIR}/installers/open-tofu/open-tofu-install.sh" "${OPEN_TOFU_VERSION}"
# install azure-cli
RUN "${TMP_COOKBOOKS_DIR}/installers/azure-cli/azure-cli-install.sh"
# install helm
RUN "${TMP_COOKBOOKS_DIR}/installers/helm/helm-install.sh" "${HELM_VERSION}"
# clean up build & tmp files
RUN "${TMP_COOKBOOKS_DIR}/setters/clean/build-cleanup.sh" \
    && rm -rf "${TMP_COOKBOOKS_DIR}"

ENTRYPOINT ["entrypoint.sh"]
