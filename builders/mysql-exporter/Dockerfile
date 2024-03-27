FROM ubuntu-base:latest

# ARG from docker-compose
ARG cookbooks_dir
ARG image_builder_dir
ARG MYSQL_EXPORTER_VERSION

# ARG
ARG TMP_COOKBOOKS_DIR='/tmp/cookbook'

# ENV
ENV MYSQL_EXPORTER_CONFIG_PATH='/etc/mysql-exporter'

# required files
COPY "${cookbooks_dir}" "${TMP_COOKBOOKS_DIR}"
COPY "${image_builder_dir}/files" /

# install requirements
RUN chmod 777 /tmp
# configure root
RUN "${TMP_COOKBOOKS_DIR}/setters/user/add/configure-root.sh"
# install cadvisor
RUN "${TMP_COOKBOOKS_DIR}/installers/prometheus/mysql-exporter/mysql-exporter-install.sh" "${MYSQL_EXPORTER_VERSION}"
# clean up build
RUN "${TMP_COOKBOOKS_DIR}/setters/clean/build-cleanup.sh"
# clean up tmp files
RUN rm -rf "${TMP_COOKBOOKS_DIR}"

ENTRYPOINT ["entrypoint.sh"]