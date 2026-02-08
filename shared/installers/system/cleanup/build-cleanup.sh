#!/bin/bash

set -e

. "${TMP_COOKBOOKS_DIR}/source/font.sh"

####################################
echo-info "APT cleanup"
####################################

# Remove unnecessary packages
apt-get autoremove -y --purge
apt-get clean

# Remove package lists
rm -rf /var/lib/apt/lists/*

####################################
echo-info "Documentation cleanup"
####################################

# Remove documentation files
rm -rf /usr/share/doc/*
rm -rf /usr/share/man/*
rm -rf /usr/share/info/*
rm -rf /usr/share/locale/*

####################################
echo-info "Temporary files cleanup"
####################################

# Remove temporary directories
rm -rf /tmp/*
rm -rf /var/tmp/*

####################################
echo-success "Cleanup completed"
####################################