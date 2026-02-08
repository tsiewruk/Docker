#!/bin/bash

set -e

. "${TMP_COOKBOOKS_DIR}/source/font.sh"

UBUNTU_RELEASE=${1}

####################################
echo-info "Installing Rabbitmq"
####################################

apt-get -y install --no-install-recommends gnupg apt-transport-https

curl -1sLf "https://keys.openpgp.org/vks/v1/by-fingerprint/0A9AF2115F4687BD29803A206B73A36E6026DFCA" | sudo gpg --dearmor | sudo tee /usr/share/keyrings/com.rabbitmq.team.gpg > /dev/null
tee /etc/apt/sources.list.d/rabbitmq.list <<EOF
deb [arch=amd64 signed-by=/usr/share/keyrings/com.rabbitmq.team.gpg] https://deb1.rabbitmq.com/rabbitmq-server/debian/trixie trixie main
deb [arch=amd64 signed-by=/usr/share/keyrings/com.rabbitmq.team.gpg] https://deb2.rabbitmq.com/rabbitmq-server/debian/trixie trixie main
EOF

apt-get -y install --no-install-recommends --fix-missing rabbitmq-server=${RABBITMQ_VERSION}

####################################
echo-success "Rabbitmq installation completed"
####################################