#!/usr/bin/env bash

set -e

source_dir="$(dirname "$0")"
source "${source_dir}/../../source/font.sh"

echo-info "Setting aliases"

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

declare -A alias_collection=(
    [service-status]="/etc/status.sh"
    [service-start]="/etc/start.sh"
    [service-stop]="/etc/stop.sh"
    [service-restart]="/etc/restart.sh"
)

for alias in ${!alias_collection[*]}; do
    echo "alias ${alias}=${alias_collection[${alias}]}" >> ~/.bash_aliases
done
