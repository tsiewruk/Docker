FROM ubuntu-base:latest

# ARG from docker-compose
ARG cookbooks_dir
ARG image_builder_dir

# ARG 
ARG DEBIAN_FRONTEND='noineractive'
ARG TMP_FILES_DIR='/tmp/cookbook/'
ARG TECH_USER_NAME='techuser'
ARG TECH_USER_GROUPS="${TECH_USER_NAME}"

# required files
COPY "${cookbooks_dir}" "${TMP_COOKBOOKS_DIR}"
COPY "${image_builder_dir}/files" /

# additional requirements
RUN chmod 777 /tmp
# create tech-user
RUN "${TMP_COOKBOOKS_DIR}/setters/user/add/add-user.sh" "${TECH_USER_NAME}" "${TECH_USER_GROUPS}"
# install varnish
RUN "${TMP_COOKBOOKS_DIR}/installers/varnish/varnish-install.sh"
# configure tech-user
RUN "${TMP_COOKBOOKS_DIR}/setters/user/add/configure-user.sh" "/etc/varnish" "/var/log" "/service" "/usr/local/bin" 
# clean up build & tmp files
RUN "${TMP_COOKBOOKS_DIR}/setters/clean/build-cleanup.sh" \
    && rm -rf "${TMP_COOKBOOKS_DIR}"

ENTRYPOINT ["entrypoint.sh"]