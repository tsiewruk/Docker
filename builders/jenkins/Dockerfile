FROM ubuntu-base:latest

# ARG from docker-compose
ARG cookbooks_dir
ARG image_builder_dir
ARG OPEN_JDK_VERSION
ARG JENKINS_VERSION

# ARG
ARG DEBIAN_FRONTEND='noninteractive'
ARG TMP_COOKBOOKS_DIR='/tmp/cookbooks'

# required files
COPY "${cookbooks_dir}" "${TMP_COOKBOOKS_DIR}"
COPY "${image_builder_dir}/files" /

# install requirements
RUN chmod 777 /tmp
# install git
RUN "${TMP_COOKBOOKS_DIR}/installers/git/git-install.sh"
# install open-jdk
RUN "${TMP_COOKBOOKS_DIR}/installers/open-jdk/openjdk-install.sh" "${OPEN_JDK_VERSION}"
# install jenkins
RUN "${TMP_COOKBOOKS_DIR}/installers/jenkins/jenkins-install.sh" "${JENKINS_VERSION}"
# clean up build & tmp files
RUN "${TMP_COOKBOOKS_DIR}/setters/clean/build-cleanup.sh" \
    && rm -rf "${TMP_COOKBOOKS_DIR}"

ENTRYPOINT ["entrypoint.sh"]