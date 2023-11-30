#!/usr/bin/env bash

set -e

# init database
mysql -uroot
create database zabbix character set utf8mb4 collate utf8mb4_bin;
create user zabbix@localhost identified by \'"${MYSQL_PASSWORD}"\';
grant all privileges on zabbix.* to zabbix@localhost;
set global log_bin_trust_function_creators = 1;
quit;

# import initial schema and data
zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | mysql --default-character-set=utf8mb4 -uzabbix -p zabbix

# configure db
sed -i "|# DBHost=localhost|DBHost=local|" /etc/zabbix/zabbix_server.conf
sed -i "|# DBPassword=|DBPassword=${MYSQL_PASSWORD}|" /etc/zabbix/zabbix_server.conf