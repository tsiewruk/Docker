#!/bin/bash

set -e

. "${TMP_COOKBOOKS_DIR}/source/font.sh"

TZ="${1}"

####################################
echo-info "Setting timezone - ${TZ}"
####################################

if [ -f "/usr/share/zoneinfo/${TZ}" ]; then
    ln -snf "/usr/share/zoneinfo/${TZ}" /etc/localtime
    echo "${TZ}" > /etc/timezone
    date
else
    echo-error "Wrong time zone!"
    exit 1
fi