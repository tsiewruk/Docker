#!/bin/bash

set -e

function echo-error {
    echo -e "\033[1;31m $1 \033[00m"
}

function echo-info {
    echo -e "\033[1;33m $1 \033[00m"
}

function echo-success {
    echo -e "\033[1;32m $1 \033[00m"
}

function echo-normal {
    echo -e "\033[0m $1"
}