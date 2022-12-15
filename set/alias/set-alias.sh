#!/bin/bash

set -e

source_dir="$(dirname "$0")"
source ${source_dir}/../../source/font.sh

echo-info "Setting aliases"

if [ -f ~/.bash_aliases ]; then
. ~/.bash_aliases
fi

echo "alias 'service status'='bash /etc/status.sh'"
echo "alias 'service restart'='bash /etc/restart.sh'"
echo "alias 'service stop'='bash /etc/stop.sh'"
echo "alias 'service start'='bash /etc/start.sh'"