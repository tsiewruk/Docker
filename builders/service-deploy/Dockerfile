FROM ubuntu-base:latest

MAINTAINER Tomasz Siewruk <tomasz.m.siewruk@gmail.com>

# ARG from docker-compose
ARG cookbooks_dir
ARG image_builder_dir
ARG ANSIBLE_VERSION
ARG PYTHON_VERSION
ARG TERRAFORM_VERSION

# ARG 
ARG DEBIAN_FRONTEND='noineractive'
ARG TMP_FILES_DIR='/tmp/cookbook/'

# ENV 

# required files
COPY "${cookbooks_dir}" "${TMP_COOKBOOKS_DIR}"
COPY "${image_builder_dir}/files" /

# additional requirements
RUN chmod 777 /tmp
# install openssh-server
RUN "${TMP_COOKBOOKS_DIR}/installers/openssh/server/openssh-install.sh"
# install ansible
RUN "${TMP_COOKBOOKS_DIR}/installers/ansible/ansible-install.sh" "${ANSIBLE_VERSION}" "${PYTHON_VERSION}"
# install terraform
RUN "${TMP_COOKBOOKS_DIR}/installers/terraform/terraform-install.sh" "${TERRAFORM_VERSION}"
# install azure-cli
RUN "${TMP_COOKBOOKS_DIR}/installers/azure-cli/azure-cli-install.sh"
# clean up build
RUN "${TMP_COOKBOOKS_DIR}/setters/clean/build-cleanup.sh"
# clean up tmp files
RUN rm -rf "${TMP_COOKBOOKS_DIR}"

ENTRYPOINT ["entrypoint.sh"]