FROM ubuntu-base:latest

# ARG from docker-compose
ARG cookbooks_dir
ARG image_builder_dir
ARG PHP_VERSION
ARG WORDPRESS_VERSION

# ARG
ARG DEBIAN_FRONTEND='noninteractive'
ARG TMP_COOKBOOKS_DIR='/tmp/cookbook'
ARG TECH_USER_NAME='techuser'
ARG TECH_USER_GROUPS="${TECH_USER_NAME}"

# ENV
ENV APP_PATH='/var/www/data'

# Security: Create specific temp directory with proper permissions
RUN mkdir -p "${TMP_COOKBOOKS_DIR}" && \
    chmod 750 "${TMP_COOKBOOKS_DIR}"

# Copy required files
COPY "${cookbooks_dir}" "${TMP_COOKBOOKS_DIR}"
COPY "${image_builder_dir}/files" /

# Install everything in one optimized layer for smaller image
RUN "${TMP_COOKBOOKS_DIR}/setters/user/add/add-user.sh" "${TECH_USER_NAME}" "${TECH_USER_GROUPS}" && \
    # Install & configure nginx
    "${TMP_COOKBOOKS_DIR}/installers/nginx/nginx-install.sh" && \
    install -d -o www-data -g www-data -m 750 "${APP_PATH}" && \
    mv "/etc/nginx/nginx.conf-custom" "/etc/nginx/nginx.conf" && \
    sed -i "s|<DOCUMENT_ROOT>|${APP_PATH}/wordpress|g" "/etc/nginx/conf.d/wordpress.conf" && \
    sed -i "s|<PHP_VERSION>|${PHP_VERSION}|g" "/etc/nginx/include.d/php.conf" && \
    # Install & configure php
    "${TMP_COOKBOOKS_DIR}/installers/php/fpm/php-install.sh" "${PHP_VERSION}" && \
    apt-get -y install --no-install-recommends "php${PHP_VERSION}-cli" \
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
                                              "php${PHP_VERSION}-pdo" && \
    mv "/etc/php/${PHP_VERSION}/fpm/php-fpm.conf-custom" "/etc/php/${PHP_VERSION}/fpm/php-fpm.conf" && \
    mv "/etc/php/${PHP_VERSION}/fpm/php.ini-custom" "/etc/php/${PHP_VERSION}/fpm/php.ini" && \
    # Install wordpress
    "${TMP_COOKBOOKS_DIR}/installers/wordpress/wordpress-install.sh" ${WORDPRESS_VERSION} && \
    # Configure tech-user
    "${TMP_COOKBOOKS_DIR}/setters/user/add/configure-user.sh" "/etc/wordpress" "/var/log" "/service" "/usr/local/bin" && \
    # Clean up build & tmp files
    "${TMP_COOKBOOKS_DIR}/setters/clean/build-cleanup.sh" && \
    rm -rf "${TMP_COOKBOOKS_DIR}"

# Security: Use non-root user
USER "${TECH_USER_NAME}":"${TECH_USER_NAME}"

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:80/wp-admin/install.php || exit 1

# Expose ports
EXPOSE 80 443

ENTRYPOINT ["entrypoint.sh"]