FROM ubuntu-base:latest

# ARG from docker-compose
ARG cookbooks_dir
ARG image_builder_dir
ARG NODE_EXPORTER_VERSION

# ARG
ARG TMP_COOKBOOKS_DIR='/tmp/cookbook'
ARG TECH_USER_NAME='techuser'
ARG TECH_USER_GROUPS="${TECH_USER_NAME}"

# required files
COPY "${cookbooks_dir}" "${TMP_COOKBOOKS_DIR}"
COPY "${image_builder_dir}/files" /

# install requirements
RUN chmod 777 /tmp
# configure tech user
RUN "${TMP_COOKBOOKS_DIR}/setters/user/add/configure-user.sh" "${TECH_USER_NAME}" "${TECH_USER_GROUPS}"
# install node-exporter
RUN "${TMP_COOKBOOKS_DIR}/installers/prometheus/node-exporter/node-exporter-install.sh" "${NODE_EXPORTER_VERSION}"
# clean up build & tmp files
RUN "${TMP_COOKBOOKS_DIR}/setters/clean/build-cleanup.sh" \
    && rm -rf "${TMP_COOKBOOKS_DIR}"

USER "${TECH_USER_NAME}":"${TECH_USER_NAME}"

ENTRYPOINT ["entrypoint.sh"]