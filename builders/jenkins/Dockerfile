FROM gitlab.slsbk.net:5050/devops/docker-builders/ubuntu-base:latest

# IN params from docker-compose
ARG cookbooks_dir
ARG image_builder_dir
ARG ALERTMANAGER_VERSION

# IN params local for builder
ARG TMP_COOKBOOKS_DIR='/tmp/cookbook'

# In params global for builder and image

# required files
COPY "${cookbooks_dir}" "${TMP_COOKBOOKS_DIR}"
COPY "${cookbooks_dir}/entrypoint/env_vars.sh" /usr/local/bin/entrypoint-tools/
COPY "${image_builder_dir}/files" /

# install additional requirements
RUN chmod 777 /tmp \
    && apt-get -y update \
    && apt-get -y install --no-install-recommends \
       dpkg-dev
# configure root
RUN "${TMP_COOKBOOKS_DIR}/setters/user/add/configure-root.sh"
# install git
RUN "${TMP_COOKBOOKS_DIR}/installers/git/git-install.sh"
# install grafana
RUN "${TMP_COOKBOOKS_DIR}/installers/alert-manager/alertmanager-install.sh" "${ALERTMANAGER_VERSION}"
# clean up build & app
RUN "${TMP_COOKBOOKS_DIR}/setters/clean/build-cleanup.sh"
# clean up files
RUN rm -rf "${TMP_COOKBOOKS_DIR}"

ENTRYPOINT ["entrypoint.sh"]
