FROM ubuntu-base:latest

# ARG from docker-compose
ARG cookbooks_dir
ARG image_builder_dir
ARG ERLANG_VERSION
ARG RABBITMQ_VERSION

# ARG build
ARG DEBIAN_FRONTEND='noineractive'
ARG TMP_FILES_DIR='/tmp/cookbook/'
ARG SSL_VERSION='1.1.1.1'

# ENV build + image
ENV UBUNTU_RELEASE='focal'

# required files
COPY "${cookbooks_dir}" "${TMP_COOKBOOKS_DIR}"
COPY "${image_builder_dir}/files" /

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
# clean up build
RUN "${TMP_COOKBOOKS_DIR}/setters/clean/build-cleanup.sh"
# clean up tmp files
RUN rm -rf "${TMP_COOKBOOKS_DIR}"

ENTRYPOINT ["entrypoint.sh"]