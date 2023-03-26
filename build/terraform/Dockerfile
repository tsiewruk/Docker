FROM ubuntu-base:latest

MAINTAINER Tomasz Siewruk <tomasz.m.siewruk@gmail.com>

# ARG from docker-compose
ARG image_cookbook_dir
ARG image_build_dir

# ARG build
ARG DEBIAN_FRONTEND='noineractive'
ARG TMP_FILES_DIR='/tmp/cookbook/'

# ENV build + image

# required files
COPY "${image_cookbook_dir}" "${TMP_FILES_DIR}"
#COPY "${image_build_dir}/files" /

# additional requirements
RUN chmod 777 /tmp
# install requirements
RUN apt-get update -y \
    && apt-get install -y --no-install-recommends dpkg-dev
# install terraform
RUN "${TMP_FILES_DIR}/install/terraform/terraform-install.sh" "${TERRAFORM_VERSION}"
# clean up
RUN "${TMP_FILES_DIR}/set/clean/clean-build.sh" \
    && rm -rf "${TMP_FILES_DIR}"

ENTRYPOINT ["entrypoint.sh"]