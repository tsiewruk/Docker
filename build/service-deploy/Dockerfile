FROM ubuntu-base:latest

MAINTAINER Tomasz Siewruk <tomasz.m.siewruk@gmail.com>

# ARG from docker-compose
ARG image_cookbook_dir
ARG image_build_dir
ARG ANSIBLE_VERSION
ARG PYTHON_VERSION
ARG TERRAFORM_VERSION

# ARG build
ARG DEBIAN_FRONTEND='noineractive'
ARG TMP_FILES_DIR='/tmp/cookbook/'

# ENV build + image

# required files
COPY "${image_cookbook_dir}" "${TMP_FILES_DIR}"
COPY "${image_build_dir}/files" /

# additional requirements
RUN chmod 777 /tmp
# install openssh-server
RUN "${TMP_FILES_DIR}/install/openssh/server/openssh-install.sh"
# install ansible
RUN "${TMP_FILES_DIR}/install/ansible/ansible-install.sh" "${ANSIBLE_VERSION}" "${PYTHON_VERSION}"
# install terraform
RUN "${TMP_FILES_DIR}/install/terraform/terraform-install.sh" "${TERRAFORM_VERSION}"
# install azure-cli
RUN "${TMP_FILES_DIR}/install/azure-cli/azure-cli-install.sh"
# clean up
RUN "${TMP_FILES_DIR}/set/clean/clean-build.sh" \
    && rm -rf "${TMP_FILES_DIR}" 

ENTRYPOINT ["entrypoint.sh"]