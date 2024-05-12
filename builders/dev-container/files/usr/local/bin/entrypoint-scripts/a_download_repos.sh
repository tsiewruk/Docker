#!/usr/bin/env bash

set -e

if [ ! -d "/opt/ansible" ]; then
    git clone https://github.com/tsiewruk/Ansible.git
fi

if [ ! -d "/opt/terraform" ]; then
    git clone https://github.com/tsiewruk/Terraform.git
fi

sed -i "s|a_download_repos=1|a_download_repos=0|" /usr/local/bin/entrypoint-scripts.env