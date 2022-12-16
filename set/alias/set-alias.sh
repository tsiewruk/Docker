#!/usr/bin/env bash

set -e

source_dir="$(dirname "$0")"
source ${source_dir}/../../source/font.sh

echo-info "Setting aliases"

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

declare -A alias_collection=(
    [service-status]="bash /etc/status.sh"
    [service-start]="bash /etc/start.sh"
    [service-stop]="bash /etc/stop.sh"
    [service-restart]="bash /etc/restart.sh"
)

for alias_c in ${!alias_collection[*]}; do
    echo 'alias \"${alias_c}\"=\"${alias_collection[${alias_c}]}\"' >> ~/.bash_aliases
done
