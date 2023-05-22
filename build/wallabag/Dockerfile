FROM ubuntu-base:latest

MAINTAINER Tomasz Siewruk <tomasz.m.siewruk@gmail.com>

# ARG from docker-compose
ARG image_cookbook_dir
ARG image_build_dir
ARG PHP_VERSION
ARG PHP_COMPOSER_VERSION

# ARG build
ARG DEBIAN_FRONTEND='noineractive'
ARG TMP_FILES_DIR='/tmp/cookbook/'
ARG ADD_GIT_DETAILS="true"

# ENV build + image

# required files
COPY "${image_cookbook_dir}" "${TMP_FILES_DIR}"
COPY "${image_build_dir}/files" /

# additional requirements
RUN chmod 777 /tmp
# install nginx & configure
RUN "${TMP_FILES_DIR}/install/nginx/nginx-install.sh" \
    && mv "/etc/nginx/nginx.conf-custom" "/etc/nginx/nginx.conf" \
    && sed -i "s|<DOCUMENT_ROOT>|${APP_DEPLOY_PATH}|g" "/etc/nginx/conf.d/wallabag.conf"
# install git
RUN "${TMP_FILES_DIR}/install/git/git-install.sh" "${ADD_GIT_DETAILS}"
# install php & configure
RUN "${TMP_FILES_DIR}/install/php/fpm/php-install.sh" "${PHP_VERSION}" \
    && mv "/etc/php/${PHP_VERSION}/cli/php.ini-custom" "/etc/php/${PHP_VERSION}/cli/php.ini" \
    && mv "/etc/php/${PHP_VERSION}/fpm/php-fpm.conf-custom" "/etc/php/${PHP_VERSION}/fpm/php-fpm.conf" \
# install pear extension
    && "${TMP_FILES_DIR}/install/php/pear/pear-install.sh" "${PHP_VERSION}" \
# required to start fpm
    && mkdir -p /var/log/php/
# install composer
RUN "${TMP_FILES_DIR}/install/php/composer/composer-install.sh" "${PHP_COMPOSER_VERSION}"
# clean up
RUN "${TMP_FILES_DIR}/set/clean/clean-build.sh" \
    && rm -rf "${TMP_FILES_DIR}"

ENTRYPOINT ["entrypoint.sh"]