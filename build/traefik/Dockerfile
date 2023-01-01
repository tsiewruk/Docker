FROM ubuntu-base:latest

MAINTAINER Tomasz Siewruk <tomasz.m.siewruk@gmail.com>

# ARG from docker-compose
ARG set_dir
ARG install_dir
ARG source_dir
ARG image_build_dir
ARG TRAEFIK_VERSION

# ARG build
ARG DEBIAN_FRONTEND='noineractive'
ARG TMP_FILES_DIR='/tmp/tmp_install'

# ENV build + image

# required files
COPY "${install_dir}" "${TMP_FILES_DIR}/install/"
COPY "${set_dir}" "${TMP_FILES_DIR}/set/"
COPY "${source_dir}" "${TMP_FILES_DIR}/source/"
COPY "${image_build_dir}/files" /

# additional requirements
RUN chmod 777 /tmp
# install openssh-server
RUN "${TMP_FILES_DIR}/install/openssh/server/openssh-install.sh"
# install traefik
RUN "${TMP_FILES_DIR}/install/traefik/traefik-install.sh" "${TRAEFIK_VERSION}"
# clean up
RUN "${TMP_FILES_DIR}/set/clean/clean-build.sh" \
    && rm -rf "${TMP_FILES_DIR}"

ENTRYPOINT ["entrypoint.sh"]
EXPOSE 80