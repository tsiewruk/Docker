FROM ubuntu-base:latest

# ARG from docker-compose
ARG cookbooks_dir
ARG image_builder_dir
ARG ERLANG_VERSION
ARG RABBITMQ_VERSION

# ARG
ARG DEBIAN_FRONTEND='noineractive'
ARG TMP_FILES_DIR='/tmp/cookbook/'
ARG SSL_VERSION='1.1.1.1'
ARG TECH_USER_NAME='techuser'
ARG TECH_USER_GROUPS="${TECH_USER_NAME}"

# ENV
ENV UBUNTU_RELEASE='focal'

# required files
COPY "${cookbooks_dir}" "${TMP_COOKBOOKS_DIR}"
COPY "${image_builder_dir}/files" /

# additional requirements
RUN chmod 777 /tmp
# install requirements
RUN apt-get -y update \
    && apt-get -y install --no-install-recommends dpkg-dev
# create tech-user
RUN "${TMP_COOKBOOKS_DIR}/setters/user/add/add-user.sh" "${TECH_USER_NAME}" "${TECH_USER_GROUPS}"
# install ssl
RUN "${TMP_COOKBOOKS_DIR}/installers/ssl/ssl-install.sh" "${SSL_VERSION}"
# install erlang
RUN "${TMP_COOKBOOKS_DIR}/installers/erlang/erlang-install.sh" "${UBUNTU_RELEASE}"
# install rabbitmq
RUN "${TMP_COOKBOOKS_DIR}/installers/rabbitmq/rabbitmq-install.sh" "${UBUNTU_RELEASE}"
# configure tech-user
RUN "${TMP_COOKBOOKS_DIR}/setters/user/add/configure-user.sh" "/etc/rabbitmq" "/var/log" "/service" "/usr/local/bin" 
# clean up build & tmp files
RUN "${TMP_COOKBOOKS_DIR}/setters/clean/build-cleanup.sh" \
    && rm -rf "${TMP_COOKBOOKS_DIR}"

ENTRYPOINT ["entrypoint.sh"]