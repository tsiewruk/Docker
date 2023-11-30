#!/usr/bin/env bash

set -e

# configure php.ini
sed -i "|;date.timezone =|date.timezone = Europe/Warsaw|" "/etc/php/${PHP_VERSION}/cli/php.ini"
sed -i "|max_execution_time = 30|max_execution_time = 600|" "/etc/php/${PHP_VERSION}/cli/php.ini"
sed -i "|max_input_time = 60|max_input_time = 600|" "/etc/php/${PHP_VERSION}/cli/php.ini"
sed -i "|memory_limit = 128M|max_input_time = 256M|" "/etc/php/${PHP_VERSION}/cli/php.ini"
sed -i "|post_max_size = 8M|post_max_size = 16M|" "/etc/php/${PHP_VERSION}/cli/php.ini"