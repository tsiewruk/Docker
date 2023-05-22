#!/usr/bin/env bash

set -e

source_dir="$(dirname $(readlink -f "$0"))"
source "${source_dir}/../../source/font.sh"

ADD_GIT_DETAILS="${1}"

echo-info "Installing Git"

apt-get -y update
apt-get -y install --no-install-recommends git

if [ "${ADD_GIT_DETAILS}" == "true" ] ; then
    echo 'export GIT_AUTHOR_NAME="Tomasz Siewruk"
export GIT_AUTHOR_EMAIL="tomasz.m.siewruk@gmail.com"
export GIT_COMMITTER_NAME="Tomasz Siewruk"
export GIT_COMMITTER_EMAIL="tomasz.m.siewruk@gmail.com"' >> "/home/${APP_DEPLOY_USER_NAME}/.bashrc"
fi