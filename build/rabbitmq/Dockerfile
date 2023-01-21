FROM ubuntu-base:latest

MAINTAINER Tomasz Siewruk <tomasz.m.siewruk@gmail.com>

# ARG from docker-compose
ARG set_dir
ARG install_dir
ARG source_dir
ARG image_build_dir
ARG ERLANG_VERSION
ARG RABBITMQ_VERSION

# ARG build
ARG DEBIAN_FRONTEND='noineractive'
ARG TMP_FILES_DIR='/tmp/tmp_install'
ARG SSL_VERSION='1.1.1.1'

# ENV build + image
ENV UBUNTU_RELEASE='focal'

# required files
COPY "${install_dir}" "${TMP_FILES_DIR}/install/"
COPY "${set_dir}" "${TMP_FILES_DIR}/set/"
COPY "${source_dir}" "${TMP_FILES_DIR}/source/"
COPY "${image_build_dir}/files" /

# additional requirements
RUN chmod 777 /tmp
# install requirements
RUN apt-get update -y \
    && apt-get install -y --no-install-recommends dpkg-dev
# install ssl
RUN "${TMP_FILES_DIR}/install/ssl/ssl-install.sh" "${SSL_VERSION}"
# install erlang
RUN "${TMP_FILES_DIR}/install/erlang/erlang-install.sh" "${UBUNTU_RELEASE}"
# install rabbitmq
RUN "${TMP_FILES_DIR}/install/rabbitmq/rabbitmq-install.sh" "${UBUNTU_RELEASE}"
# clean up
RUN "${TMP_FILES_DIR}/set/clean/clean-build.sh" \
    && rm -rf "${TMP_FILES_DIR}" \
    && apt-get purge -y dpkg-dev

ENTRYPOINT ["entrypoint.sh"]