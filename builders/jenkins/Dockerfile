FROM ubuntu-base:new

# ARG from docker-compose
ARG cookbooks_dir
ARG image_builder_dir
ARG OPEN_JDK_VERSION
ARG JENKINS_VERSION

# ARG
ARG DEBIAN_FRONTEND='noninteractive'
ARG TMP_COOKBOOKS_DIR='/tmp/cookbook'
ARG TZ='Europe/Warsaw'

# ENV

# required files
COPY "${cookbooks_dir}" "${TMP_COOKBOOKS_DIR}"
COPY "${image_builder_dir}/files" /

# install requirements
RUN chmod 777 /tmp 
# install open-jdk
RUN "${TMP_COOKBOOKS_DIR}/installers/open-jdk/openjdk-install.sh" "${OPEN_JDK_VERSION}"
# install jenkins
RUN "${TMP_COOKBOOKS_DIR}/installers/jenkins/jenkins-install.sh" "${JENKINS_VERSION}"
# clean up build
RUN "${TMP_COOKBOOKS_DIR}/setters/clean/build-cleanup.sh"
# clean up tmp files
RUN rm -rf "${TMP_COOKBOOKS_DIR}"

ENTRYPOINT ["entrypoint.sh"]