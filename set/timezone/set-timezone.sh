#!/usr/bin/env bash

set -e

source_dir="$(dirname "$0")"
source ${source_dir}/../../source/font.sh

TIMEZONE="${1}"

echo-info "Setting timezone - ${TIMEZONE}"

if [ -f /usr/share/zoneinfo/"${TIMEZONE}" ]; then
    ln -snf /usr/share/zoneinfo/"${TIMEZONE}" /etc/localtime
    echo "${TIMEZONE}" > /etc/timezone
    date
else
    echo-error "Bad time zone!"
    exit 1
fi
