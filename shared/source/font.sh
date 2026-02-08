#!/bin/bash

# Logger functions for colored output in installation scripts
# These functions are sourced globally in debian-base-image

# Red color for error messages
function echo-error {
    echo -e "\033[1;31m ${1} \033[00m"
}

# Yellow color for info messages
function echo-info {
    echo -e "\033[1;33m ${1} \033[00m"
}

# Green color for success messages
function echo-success {
    echo -e "\033[1;32m ${1} \033[00m"
}

# Normal color for normal messages
function echo-normal {
    echo -e "\033[0m ${1}"
}