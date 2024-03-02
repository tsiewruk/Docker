FROM ubuntu-base:latest

# ARG from docker-compose
ARG cookbooks_dir
ARG image_builder_dir
ARG MYSQL_VERSION

# ARG
ARG DEBIAN_FRONTEND='noninteractive'
ARG TMP_COOKBOOKS_DIR='/tmp/cookbook'

# required files
COPY "${cookbooks_dir}" "${TMP_COOKBOOKS_DIR}"
COPY "${image_builder_dir}/files" /

# install requirements
RUN chmod 777 /tmp
# configure root
RUN "${TMP_COOKBOOKS_DIR}/setters/user/add/configure-root.sh"
# install mysql
RUN "${TMP_COOKBOOKS_DIR}/installers/mysql/mysql-install.sh" ${MYSQL_VERSION} ${MYSQL_ROOT_PASS} 
# clean up build
RUN "${TMP_COOKBOOKS_DIR}/setters/clean/build-cleanup.sh"
# clean up tmp files
RUN rm -rf "${TMP_COOKBOOKS_DIR}"

EXPOSE 3306 33060
ENTRYPOINT ["entrypoint.sh"]