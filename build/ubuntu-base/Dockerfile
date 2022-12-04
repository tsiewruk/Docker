FROM ubuntu:22.04

MAINTAINER Tomasz Siewruk <tomasz.m.siewruk@gmail.com>

# ARG from docker-compose
ARG set_dir
ARG install_dir
ARG image_build_dir

# ARG build
ARG DEBIAN_FRONTEND='noineractive' 
ARG TZ="Europe/Warsaw"
ARG TMP_FILES_DIR='/tmp/tmp_install'

# ENV build + image

# required files
COPY "${install_dir}" "${TMP_SET_DIR}"
COPY "${set_dir}" "${TMP_INSTALL_DIR}"
COPY "${image_build_dir}/files" /

# additional requirements
RUN chmod 777 /tmp && apt-get update -y && apt-get upgrade -y
# install requirements
RUN apt-get install -y --no-install-recommends \
       less vim \
       ca-certificates gnupg \
       s6 sudo htop locales logrotate strace iftop \
       bash-completion dialog \
       rsync telnet net-tools iputils-ping curl wget zip
       apt-utils apt-transport-https lsb-release software-properties-common
# set timezone
RUN "${TMP_FILES_DIR}/set/timezone/timezone-set.sh" "${TZ}"
# set locals
RUN locale-gen en_US.UTF-8 pl_PL.UTF-8
# clean up
RUN apt-get clean \
    && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*
