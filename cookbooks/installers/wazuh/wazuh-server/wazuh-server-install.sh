#!/bin/bash

set -e

. "${TMP_COOKBOOKS_DIR}/source/font.sh"

#source_dir=$(dirname $(readlink -f "$0"))
#cp -R "${source_dir}/files/service" /

####################################
echo-info "Installing Wazuh Server - ${WAZUH_SERVER_VERSION}"
####################################

# add repositry
curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | gpg --no-default-keyring --keyring gnupg-ring:/usr/share/keyrings/wazuh.gpg --import && chmod 644 /usr/share/keyrings/wazuh.gpg
echo "deb [signed-by=/usr/share/keyrings/wazuh.gpg] https://packages.wazuh.com/4.x/apt/ stable main" | tee -a /etc/apt/sources.list.d/wazuh.list
apt-get update -y

# install wazuh-server
apt-get -y install --no-install-recommends wazuh-manager