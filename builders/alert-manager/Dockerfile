FROM ubuntu-base:latest

# ARG from docker-compose
ARG cookbooks_dir
ARG image_builder_dir
ARG ALERTMANAGER_VERSION

# ARG
ARG TMP_COOKBOOKS_DIR='/tmp/cookbook'
ARG TECH_USER_NAME='techuser'

# required files
COPY "${cookbooks_dir}" "${TMP_COOKBOOKS_DIR}"
COPY "${image_builder_dir}/files" /

# install requirements
RUN chmod 777 /tmp
# configure tech user
RUN "${TMP_COOKBOOKS_DIR}/setters/user/add/configure-user.sh" "${TECH_USER_NAME}"
# install git
RUN "${TMP_COOKBOOKS_DIR}/installers/git/git-install.sh"
# install alert-manager
RUN "${TMP_COOKBOOKS_DIR}/installers/prometheus/alert-manager/alertmanager-install.sh" "${ALERTMANAGER_VERSION}"
# clean up build
RUN "${TMP_COOKBOOKS_DIR}/setters/clean/build-cleanup.sh"
# clean up tmp files
RUN rm -rf "${TMP_COOKBOOKS_DIR}"

USER "${TECH_USER_NAME}":"${TECH_USER_NAME}"

ENTRYPOINT ["entrypoint.sh"]