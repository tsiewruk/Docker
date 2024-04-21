#!/usr/bin/env bash

set -e

if [ ! -d "/opt/ansible" ]; then
    git clone https://github.com/tsiewruk/Ansible.git

if [ ! -d "/opt/terraform" ]; then
    git clone https://github.com/tsiewruk/Terraform.git
fi

sed -i "s|a_download_repos=1|a_download_repos=0|" /etc/entrypoint-scripts.env