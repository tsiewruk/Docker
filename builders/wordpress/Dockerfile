FROM ubuntu-base:latest

# ARG from docker-compose
ARG cookbooks_dir
ARG image_builder_dir

# ARG
ARG TMP_COOKBOOKS_DIR='/tmp/cookbook'
ARG APP_PATG='/var/www/data/'

# required files
COPY "${cookbooks_dir}" "${TMP_COOKBOOKS_DIR}"
COPY "${image_builder_dir}/files" /

# install requirements
RUN chmod 777 /tmp
# configure root
RUN "${TMP_COOKBOOKS_DIR}/setters/user/add/configure-root.sh"
# install wazuh
RUN "${TMP_COOKBOOKS_DIR}/installers/wazuh/wazuh-install.sh" "${WAZUH_VERSION}" "${INDEXER_NODE_1_IP}" "${WAZUH_MANAGER_NODE_1_IP}" "${DASHBOARD_NODE_1_IP}"
# clean up build
RUN "${TMP_COOKBOOKS_DIR}/setters/clean/build-cleanup.sh"
# clean up tmp files
RUN rm -rf "${TMP_COOKBOOKS_DIR}"

ENTRYPOINT ["entrypoint.sh"]