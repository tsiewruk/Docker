#!/bin/bash

set -e

. "${TMP_COOKBOOKS_DIR}/source/font.sh"

#source_dir=$(dirname $(readlink -f "$0"))
#cp -R "${source_dir}/files/service" /

WAZUH_DASHBOARD_VERSION="${1}"

####################################
echo-info "Installing Wazuh Dashboard - ${WAZUH_DASHBOARD_VERSION}"
####################################

# requirements
apt-get update -y
apt-get install -y --no-install-recommends debhelper libcap2-bin

# add repositry
curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | gpg --no-default-keyring --keyring gnupg-ring:/usr/share/keyrings/wazuh.gpg --import && chmod 644 /usr/share/keyrings/wazuh.gpg
echo "deb [signed-by=/usr/share/keyrings/wazuh.gpg] https://packages.wazuh.com/4.x/apt/ stable main" | tee -a /etc/apt/sources.list.d/wazuh.list
apt-get update -y

# install wazuh-dashboard
apt-get -y install --no-install-recommends wazuh-dashboard