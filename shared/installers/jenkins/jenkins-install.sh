#!/bin/bash
set -e

. "${TMP_COOKBOOKS_DIR}/source/font.sh"

source_dir=$(dirname $(readlink -f "$0"))
cp -R "${source_dir}/files/service" /

JENKINS_VERSION=${1}
OPEN_JDK_VERSION=${2}

####################################
echo-info "Installing Jenkins version - ${JENKINS_VERSION} with Open-JDK version - ${OPEN_JDK_VERSION}"
####################################

apt-get -y update
apt-get -y install --no-install-recommends fontconfig openjdk-${OPEN_JDK_VERSION}-jre
wget -O /etc/apt/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | tee /etc/apt/sources.list.d/jenkins.list > /dev/null
apt-get -y update
apt-get -y install --no-install-recommends jenkins=${JENKINS_VERSION}

####################################
echo-success "Jenkins installation completed"
####################################