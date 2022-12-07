#!/bin/bash

set -e

TIMEZONE="${1}"

echo "Set timezone - ${TIMEZONE}"

if [ -f /usr/share/zoneinfo/"${TIMEZONE}" ]; then
    ln -snf /usr/share/zoneinfo/"${TIMEZONE}" /etc/localtime
    echo "${TIMEZONE}" > /etc/timezone
    date
else
    echo "Bad time zone!"
    exit 1
fi
