FROM ubuntu-base:latest

# ARG from docker-compose
ARG image_cookbook_dir
ARG image_build_dir
ARG TRAEFIK_VERSION
ARG CERT_CONFIG

# ARG 
ARG DEBIAN_FRONTEND='noineractive'
ARG TMP_FILES_DIR='/tmp/cookbook/'

# ENV

# required files
COPY "${image_cookbook_dir}" "${TMP_FILES_DIR}"
COPY "${image_build_dir}/files" /

# additional requirements
RUN chmod 777 /tmp
# install openssh-server
RUN "${TMP_FILES_DIR}/install/openssh/server/openssh-install.sh"
# install traefik
RUN "${TMP_FILES_DIR}/install/traefik/traefik-install.sh" "${TRAEFIK_VERSION}"
# clean up build
RUN "${TMP_COOKBOOKS_DIR}/setters/clean/build-cleanup.sh"
# clean up tmp files
RUN rm -rf "${TMP_COOKBOOKS_DIR}"

EXPOSE 80
ENTRYPOINT ["entrypoint.sh"]