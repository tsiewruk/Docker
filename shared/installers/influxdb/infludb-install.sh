#!/bin/bash

set -e

. "${TMP_COOKBOOKS_DIR}/source/font.sh"

INFLUXDB_VERSION=${1}

####################################
echo-info "Installing InfluxDB"
####################################

curl --silent --location -O https://repos.influxdata.com/influxdata-archive.key
gpg --show-keys --with-fingerprint --with-colons ./influxdata-archive.key 2>&1 | grep -q '^fpr:\+24C975CBA61A024EE1B631787C3D57159FC2F927:$' && cat influxdata-archive.key | gpg --dearmor | tee /etc/apt/keyrings/influxdata-archive.gpg > /dev/null
echo 'deb [signed-by=/etc/apt/keyrings/influxdata-archive.gpg] https://repos.influxdata.com/debian stable main' | tee /etc/apt/sources.list.d/influxdata.list
apt-get -y update
apt-get -y install --no-install-recommends influxdb=${INFLUXDB_VERSION}


####################################
echo-success "InfluxDB installation completed"
####################################