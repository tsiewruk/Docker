FROM ubuntu-base:latest

# ARG from docker-compose
ARG cookbooks_dir
ARG image_builder_dir
ARG GRAFANA_VERSION

# ARG
ARG TMP_COOKBOOKS_DIR='/tmp/cookbook'

# ENV
ENV MYSQL_EXPORTER_CONFIG_PATH='/etc/mysql-exporter'
ENV grafana_organization_name='MY_ORGANIZATION'
ENV grafana_organization_theme='dark'
ENV grafana_organization_weekstart='monday'
ENV grafana_organization_timezone='Europe/Warsaw'
ENV grafana_admin_name='Admin'
ENV grafana_admin_login='admin'
ENV grafana_admin_old_password='admin'
ENV grafana_admin_password='password'
ENV grafana_admin_email='email@email.com'
ENV smtp_user='user'
ENV smtp_password='password'
ENV smtp_email='email@email.com'
ENV instance_name='Grafana Monitoring'

# required files
COPY "${cookbooks_dir}" "${TMP_COOKBOOKS_DIR}"
COPY "${image_builder_dir}/files" /

# install requirements
RUN chmod 777 /tmp
# configure root
RUN "${TMP_COOKBOOKS_DIR}/setters/user/add/configure-root.sh"
# install grafana
RUN "${TMP_COOKBOOKS_DIR}/installers/grafana/grafana-install.sh" "${GRAFANA_VERSION}"
# clean up build
RUN "${TMP_COOKBOOKS_DIR}/setters/clean/build-cleanup.sh"
# clean up tmp files
RUN rm -rf "${TMP_COOKBOOKS_DIR}"

ENTRYPOINT ["entrypoint.sh"]