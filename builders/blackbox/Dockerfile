FROM ubuntu-base:latest

# ARG from docker-compose
ARG cookbooks_dir
ARG image_builder_dir
ARG BLACKBOX_VERSION

# ARG 
ARG TMP_COOKBOOKS_DIR='/tmp/cookbook'

# ENV
ENV BLACKBOX_CONFIG_PATH='/etc/blackbox'

# required files
COPY "${cookbooks_dir}" "${TMP_COOKBOOKS_DIR}"
COPY "${image_builder_dir}/files" /

# install requirements
RUN chmod 777 /tmp
# configure root
RUN "${TMP_COOKBOOKS_DIR}/setters/user/add/configure-root.sh"
# install git
RUN "${TMP_COOKBOOKS_DIR}/installers/git/git-install.sh"
# install blackbox
RUN "${TMP_COOKBOOKS_DIR}/installers/blackbox/blackbox-install.sh" "${BLACKBOX_VERSION}"
# clean up build & app
RUN "${TMP_COOKBOOKS_DIR}/setters/clean/build-cleanup.sh"
# clean up files
RUN rm -rf "${TMP_COOKBOOKS_DIR}"

ENTRYPOINT ["entrypoint.sh"]