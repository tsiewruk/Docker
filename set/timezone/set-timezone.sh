#!/bin/bash

set -e

TZ="${1}"

if [-f "/usr/share/zoneinfo/${TZ}" ]; then
	ln -snf "/usr/share/zoneifo/${TZ}" /etc/localtime
	echo "${TZ}" > /etc/timezome
	date
else
	echo 'Bad time zone!'
	exit 1
fi
