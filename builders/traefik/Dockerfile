FROM ubuntu-base:latest

# ARG from docker-compose
ARG cookbooks_dir
ARG image_builder_dir
ARG TRAEFIK_VERSION
ARG CERT_CONFIG

# ARG 
ARG DEBIAN_FRONTEND='noineractive'
ARG TMP_FILES_DIR='/tmp/cookbook/'

# required files
COPY "${cookbooks_dir}" "${TMP_COOKBOOKS_DIR}"
COPY "${image_builder_dir}/files" /

# additional requirements
RUN chmod 777 /tmp
# install openssh-server
RUN "${TMP_COOKBOOKS_DIR}/installers/openssh/server/openssh-install.sh"
# install traefik
RUN "${TMP_COOKBOOKS_DIR}/installers/traefik/traefik-install.sh" "${TRAEFIK_VERSION}"
# clean up build & tmp files
RUN "${TMP_COOKBOOKS_DIR}/setters/clean/build-cleanup.sh" \
    && rm -rf "${TMP_COOKBOOKS_DIR}"

EXPOSE 80
ENTRYPOINT ["entrypoint.sh"]