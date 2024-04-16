FROM ubuntu:22.04

# ARG from docker-compose
ARG cookbooks_dir
ARG image_builder_dir

# ARG
ARG DEBIAN_FRONTEND='noninteractive'
ARG TMP_COOKBOOKS_DIR='/tmp/cookbook'
ARG TZ='Europe/Warsaw'

# required files
COPY "${cookbooks_dir}" "${TMP_COOKBOOKS_DIR}"
COPY "${image_builder_dir}/files" /

# additional requirements
RUN chmod 777 /tmp && apt-get update -y && apt-get upgrade -y
# install requirements
RUN apt-get -y install --no-install-recommends \
    less vim tzdata \
    ca-certificates gnupg \
    s6 sudo htop locales logrotate \
    bash-completion dialog procps \
    rsync telnet net-tools iputils-ping curl wget zip \
    apt-utils apt-transport-https lsb-release software-properties-common
# set timezone
RUN "${TMP_COOKBOOKS_DIR}/setters/timezone/timezone-set.sh" "${TZ}"
# set locals
RUN locale-gen en_US.UTF-8 pl_PL.UTF-8
# clean up tmp files
RUN rm -rf "${TMP_COOKBOOKS_DIR}"