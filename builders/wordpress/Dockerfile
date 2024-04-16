FROM ubuntu-base:latest

# ARG from docker-compose
ARG cookbooks_dir
ARG image_builder_dir
ARG PHP_VERSION
ARG WORDPRESS_VERSION

# ARG
ARG DEBIAN_FRONTEND='noninteractive'
ARG TMP_COOKBOOKS_DIR='/tmp/cookbook'

# ENV
ENV APP_PATH='/var/www/data'

# required files
COPY "${cookbooks_dir}" "${TMP_COOKBOOKS_DIR}"
COPY "${image_builder_dir}/files" /

# install requirements
RUN chmod 777 /tmp
# configure root
RUN "${TMP_COOKBOOKS_DIR}/setters/user/add/configure-root.sh"
# install & configure nginx
RUN "${TMP_COOKBOOKS_DIR}/installers/nginx/nginx-install.sh" \
    && install -d -o www-data -g www-data -m 750 "${APP_PATH}" \
    && mv "/etc/nginx/nginx.conf-custom" "/etc/nginx/nginx.conf" \
    && sed -i "s|<DOCUMENT_ROOT>|${APP_PATH}/wordpress|g" "/etc/nginx/conf.d/wordpress.conf" \
    && sed -i "s|<PHP_VERSION>|${PHP_VERSION}|g" "/etc/nginx/include.d/php.conf"
# install & configure php
RUN "${TMP_COOKBOOKS_DIR}/installers/php/fpm/php-install.sh" "${PHP_VERSION}" \
    && apt-get -y install --no-install-recommends "php${PHP_VERSION}-cli" \
                                                  "php${PHP_VERSION}-zip" \
                                                  "php${PHP_VERSION}-mbstring" \
                                                  "php${PHP_VERSION}-gd" \
                                                  "php${PHP_VERSION}-bcmath" \
                                                  "php${PHP_VERSION}-soap" \
                                                  "php${PHP_VERSION}-curl" \
                                                  "php${PHP_VERSION}-xml" \
                                                  "php${PHP_VERSION}-yaml" \
                                                  "php${PHP_VERSION}-imap" \
                                                  "php${PHP_VERSION}-mysql" \
                                                  "php${PHP_VERSION}-sqlite" \
                                                  "php${PHP_VERSION}-odbc" \
                                                  "php${PHP_VERSION}-pdo" \
                                                  "php${PHP_VERSION}-odbc" \
    && mv "/etc/php/${PHP_VERSION}/fpm/php-fpm.conf-custom" "etc/php/${PHP_VERSION}/fpm/php-fpm.conf" \
    && mv "/etc/php/${PHP_VERSION}/fpm/php.ini-custom" "/etc/php/${PHP_VERSION}/fpm/php.ini"
# install wordpress
RUN "${TMP_COOKBOOKS_DIR}/installers/wordpress/wordpress-install.sh" ${WORDPRESS_VERSION}                                                 
# clean up build & tmp files
RUN "${TMP_COOKBOOKS_DIR}/setters/clean/build-cleanup.sh" \
    && rm -rf "${TMP_COOKBOOKS_DIR}"

ENTRYPOINT ["entrypoint.sh"]