#!/bin/bash

set -e

. "${TMP_COOKBOOKS_DIR}/source/font.sh"

source_dir=$(dirname $(readlink -f "$0"))
cp -R "${source_dir}/files/service" /

WAZUH_VERSION="${1}"
INDEXER_NODE_1_IP="${2}"
WAZUH_MANAGER_NODE_1_IP="${3}"
DASHBOARD_NODE_1_IP="${4}"

####################################
echo-info "Installing Wazuh (single node) - ${WAZUH_VERSION}"
####################################

# initial configuration
cd /tmp/wazuh
curl -sO https://packages.wazuh.com/${WAZUH_VERSION}/wazuh-install.sh
curl -sO https://packages.wazuh.com/${WAZUH_VERSION}/config.yml

sed -i "s|<indexer-node-ip>|${INDEXER_NODE_1_IP}|" ./config.yml
sed -i "s|<wazuh-manager-ip>|${WAZUH_MANAGER_NODE_1_IP}|" ./config.yml
sed -i "s|<dashboard-node-ip>|${DASHBOARD_NODE_1_IP}|" ./config.yml

bash wazuh-install.sh --generate-config-files

# install indexer
curl -sO https://packages.wazuh.com/${WAZUH_VERSION}/wazuh-install.sh
bash wazuh-install.sh --wazuh-indexer node-1

# getting dashboard credentials
tar -axf wazuh-install-files.tar wazuh-install-files/wazuh-passwords.txt -O | grep -P "\'admin\'" -A 1 > /opt/wazuh

# curl -k -u admin:<ADMIN_PASSWORD> https://<INDEXER_NODE_1_IP>:9200