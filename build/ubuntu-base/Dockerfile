FROM ubuntu:22.04

MAINTAINER Tomasz Siewruk <tomasz.m.siewruk@gmail.com>

# ARG from docker-compose
ARG set_dir
ARG install_dir
ARG image_build_dir

# ARG build
ARG DEBIAN_FRONTEND='noineractive' 
ARG TMP_FILES_DIR='/tmp/tmp_install'
ARG TIMEZONE='Europe/Warsaw'

# ENV build + image

# required files
COPY "${install_dir}" "${TMP_FILES_DIR}/install/"
COPY "${set_dir}" "${TMP_FILES_DIR}/set/"
COPY "${image_build_dir}/files" /

# additional requirements
RUN chmod 777 /tmp && apt-get update -y && apt-get upgrade -y
# install requirements
RUN apt-get install -y --no-install-recommends \
       less vim \
       ca-certificates gnupg tzdata \
       s6 sudo htop locales logrotate strace iftop \
       bash-completion dialog \
       rsync telnet net-tools iputils-ping curl wget zip \
       apt-utils apt-transport-https lsb-release software-properties-common
# set timezone
RUN "${TMP_FILES_DIR}/set/timezone/set-timezone.sh" "${TIMEZONE}"
# set locals
RUN locale-gen en_US.UTF-8 pl_PL.UTF-8
# clean up
RUN "${TMP_FILES_DIR}/set/clean/clean-build.sh" \
    && rm -rf "${TMP_FILES_DIR}"
