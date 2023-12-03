FROM ubuntu-base:new

# ARG from docker-compose
ARG image_cookbook_dir
ARG image_build_dir

# ARG 
ARG DEBIAN_FRONTEND='noineractive'
ARG TMP_FILES_DIR='/tmp/cookbook/'

# required files
COPY "${image_cookbook_dir}" "${TMP_FILES_DIR}"
COPY "${image_build_dir}/files" /

# additional requirements
RUN chmod 777 /tmp
# install varnish
RUN "${TMP_FILES_DIR}/install/varnish/varnish-install.sh"
# clean up build
RUN "${TMP_COOKBOOKS_DIR}/setters/clean/build-cleanup.sh"
# clean up tmp files
RUN rm -rf "${TMP_COOKBOOKS_DIR}"

ENTRYPOINT ["entrypoint.sh"]