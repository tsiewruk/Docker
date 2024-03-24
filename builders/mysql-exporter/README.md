# Instruction

## Required Grants in DB
`
CREATE USER 'exporter'@'localhost' IDENTIFIED BY 'XXXXXXXX' WITH MAX_USER_CONNECTIONS 3;
GRANT PROCESS, REPLICATION CLIENT, SELECT ON *.* TO 'exporter'@'localhost';
`

## Prepare configuration
`
    [client]
    user = foo
    password = foo123
    [client.servers]
    user = bar
    password = bar123
`
in /etc/mysql-exporter/mysql-exporter.cnf

## Prepare Promethues configuration
`
    - job_name: mysql # To get metrics about the mysql exporter’s targets
      params:
        # Not required. Will match value to child in config file. Default value is `client`.
        auth_module: [client.servers]
      static_configs:
        - targets:
          # All mysql hostnames or unix sockets to monitor.
          - server1:3306
          - server2:3306
          - unix:///run/mysqld/mysqld.sock
      relabel_configs:
        - source_labels: [__address__]
          target_label: __param_target
        - source_labels: [__param_target]
          target_label: instance
        - target_label: __address__
          # The mysqld_exporter host:port
          replacement: localhost:9104
`

---
more: https://github.com/prometheus/mysqld_exporter