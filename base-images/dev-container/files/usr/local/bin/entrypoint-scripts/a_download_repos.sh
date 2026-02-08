#!/usr/bin/env bash

set -e

repository_path="/opt"
if [ ! -d "/opt/ansible" ]; then
    git clone https://github.com/tsiewruk/Ansible.git ${repository_path)/ansible
fi

if [ ! -d "/opt/terraform" ]; then
    git clone https://github.com/tsiewruk/Terraform.git ${repository_path)/terraform
fi

sed -i "s|a_download_repos=1|a_download_repos=0|" /usr/local/bin/entrypoint-scripts.env