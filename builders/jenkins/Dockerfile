FROM ubuntu-base:latest

# IN params from docker-compose
ARG cookbooks_dir
ARG image_builder_dir

# IN params local for builder
ARG TMP_COOKBOOKS_DIR='/tmp/cookbook'

# In params global for builder and image

# required files
COPY "${cookbooks_dir}" "${TMP_COOKBOOKS_DIR}"
COPY "${image_builder_dir}/files" /

# install additional requirements
RUN chmod 777 /tmp 
#
# clean up build & app
RUN "${TMP_COOKBOOKS_DIR}/setters/clean/build-cleanup.sh"
# clean up files
RUN rm -rf "${TMP_COOKBOOKS_DIR}"

ENTRYPOINT ["entrypoint.sh"]
