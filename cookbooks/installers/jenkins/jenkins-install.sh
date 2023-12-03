#!/bin/bash

set -e

. "${TMP_COOKBOOKS_DIR}/source/font.sh"

JENKINS_VERSION="${1}"

####################################
echo-info "Installing Jenkins version - ${JENKINS_VERSION}"
####################################

wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key |sudo gpg --dearmor -o /usr/share/keyrings/jenkins.gpg
sh -c 'echo deb [signed-by=/usr/share/keyrings/jenkins.gpg] http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
apt-get update -y
apt-get install -y jenkins