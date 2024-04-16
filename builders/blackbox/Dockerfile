FROM ubuntu-base:latest

# ARG from docker-compose
ARG cookbooks_dir
ARG image_builder_dir
ARG BLACKBOX_VERSION
ARG TECH_USER_NAME='techuser'

# ARG 
ARG TMP_COOKBOOKS_DIR='/tmp/cookbook'
ARG TECH_USER_NAME='techuser'
ARG TECH_USER_GROUPS="${TECH_USER_NAME}"

# ENV
ENV BLACKBOX_CONFIG_PATH='/etc/blackbox'

# required files
COPY "${cookbooks_dir}" "${TMP_COOKBOOKS_DIR}"
COPY "${image_builder_dir}/files" /

# install requirements
RUN chmod 777 /tmp
# configure tech user
RUN "${TMP_COOKBOOKS_DIR}/setters/user/add/configure-user.sh" "${TECH_USER_NAME}" "${TECH_USER_GROUPS}"
# install git
RUN "${TMP_COOKBOOKS_DIR}/installers/git/git-install.sh"
# install blackbox
RUN "${TMP_COOKBOOKS_DIR}/installers/prometheus/blackbox/blackbox-install.sh" "${BLACKBOX_VERSION}"
# clean up build & tmp files
RUN "${TMP_COOKBOOKS_DIR}/setters/clean/build-cleanup.sh" \
    && rm -rf "${TMP_COOKBOOKS_DIR}"

USER "${TECH_USER_NAME}":"${TECH_USER_NAME}"

ENTRYPOINT ["entrypoint.sh"]