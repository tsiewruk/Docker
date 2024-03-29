FROM ubuntu-base:latest

# ARG from docker-compose
ARG cookbooks_dir
ARG image_builder_dir
ARG ANSIBLE_VERSION
ARG PYTHON_VERSION
ARG TERRAFORM_VERSION

# ARG 
ARG DEBIAN_FRONTEND='noineractive'
ARG TMP_FILES_DIR='/tmp/cookbook/'

# required files
COPY "${cookbooks_dir}" "${TMP_COOKBOOKS_DIR}"
COPY "${image_builder_dir}/files" /

# additional requirements
RUN chmod 777 /tmp
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
# install azure-cli
RUN "${TMP_COOKBOOKS_DIR}/installers/azure-cli/azure-cli-install.sh"
# clean up build
RUN "${TMP_COOKBOOKS_DIR}/setters/clean/build-cleanup.sh"
# clean up tmp files
RUN rm -rf "${TMP_COOKBOOKS_DIR}"

ENTRYPOINT ["entrypoint.sh"]
