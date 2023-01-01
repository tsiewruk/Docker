FROM ubuntu-base 

MAINTAINER Tomasz Siewruk <tomasz.m.siewruk@gmail.com>

# ARG from docker-compose
ARG set_dir
ARG install_dir
ARG source_dir
ARG image_build_dir

# ARG build
ARG DEBIAN_FRONTEND='noineractive' 
ARG TMP_FILES_DIR='/tmp/tmp_install'
ARG JAVA_VERSION='11'

# ENV build + image

# required files
COPY "${install_dir}" "${TMP_FILES_DIR}/install/"
COPY "${set_dir}" "${TMP_FILES_DIR}/set/"
COPY "${source_dir}" "${TMP_FILES_DIR}/source/"
COPY "${image_build_dir}/files" /

# additional requirements
RUN chmod 777 /tmp \
    && apt-get update -y
# install java
RUN "${TMP_FILES_DIR}/install/java/java-install.sh" "${JAVA_VERSION}"
# install jenkins
RUN "${TMP_FILES_DIR}/install/jenkins/jenkins-install.sh"
# clean up
RUN "${TMP_FILES_DIR}/set/clean/clean-build.sh" \
    && rm -rf "${TMP_FILES_DIR}"

CMD ["entrypoint.sh"]
