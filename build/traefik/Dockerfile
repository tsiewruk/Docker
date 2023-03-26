FROM ubuntu-base:latest

MAINTAINER Tomasz Siewruk <tomasz.m.siewruk@gmail.com>

# ARG from docker-compose
ARG image_cookbook_dir
ARG image_build_dir
ARG TRAEFIK_VERSION

# ARG build
ARG DEBIAN_FRONTEND='noineractive'
ARG TMP_FILES_DIR='/tmp/cookbook/'

# ENV build + image

# required files
COPY "${image_cookbook_dir}" "${TMP_FILES_DIR}"
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

EXPOSE 80
ENTRYPOINT ["entrypoint.sh"]