#!/bin/bash

# Vault Cluster Management Script for 3 Nodes

# Konfiguracja IP nodów - ZASTĄP RZECZYWISTYMI IP
NODE1_IP="192.168.1.10"  # Zastąp IP noda 1
NODE2_IP="192.168.1.11"  # Zastąp IP noda 2  
NODE3_IP="192.168.1.12"  # Zastąp IP noda 3

case "$1" in
    setup)
        echo "Setting up Vault cluster configuration..."
        
        # Aktualizuj IP w konfiguracjach
        for config in vault-configs/node*.hcl; do
            sed -i "s/NODE1_IP/$NODE1_IP/g" $config
            sed -i "s/NODE2_IP/$NODE2_IP/g" $config
            sed -i "s/NODE3_IP/$NODE3_IP/g" $config
        done
        
        # Aktualizuj IP w skryptach zarządzania
        sed -i "s/NODE1_IP/$NODE1_IP/g" vault-node1-manage.sh
        sed -i "s/NODE2_IP/$NODE2_IP/g" vault-node2-manage.sh
        sed -i "s/NODE3_IP/$NODE3_IP/g" vault-node3-manage.sh
        
        echo "Configuration updated with IPs:"
        echo "  Node 1: $NODE1_IP"
        echo "  Node 2: $NODE2_IP"
        echo "  Node 3: $NODE3_IP"
        echo ""
        echo "Now copy the appropriate files to each node:"
        echo "  Node 1: vault-node1-compose.yml, vault-node1-manage.sh, vault-configs/node1.hcl"
        echo "  Node 2: vault-node2-compose.yml, vault-node2-manage.sh, vault-configs/node2.hcl"
        echo "  Node 3: vault-node3-compose.yml, vault-node3-manage.sh, vault-configs/node3.hcl"
        ;;
    start)
        echo "Starting Vault cluster on all nodes..."
        echo "Run these commands on each node:"
        echo ""
        echo "On Node 1 ($NODE1_IP):"
        echo "  ./vault-node1-manage.sh start"
        echo ""
        echo "On Node 2 ($NODE2_IP):"
        echo "  ./vault-node2-manage.sh start"
        echo ""
        echo "On Node 3 ($NODE3_IP):"
        echo "  ./vault-node3-manage.sh start"
        ;;
    init)
        echo "Initializing Vault cluster..."
        echo "1. First, start all nodes"
        echo "2. Then run on Node 1:"
        echo "   ./vault-node1-manage.sh init"
        echo "3. Copy vault-node1-keys.txt to other nodes"
        echo "4. Unseal all nodes:"
        echo "   ./vault-node1-manage.sh unseal"
        echo "   ./vault-node2-manage.sh unseal"
        echo "   ./vault-node3-manage.sh unseal"
        ;;
    status)
        echo "Checking Vault cluster status..."
        echo ""
        for i in 1 2 3; do
            NODE_IP_VAR="NODE${i}_IP"
            NODE_IP=${!NODE_IP_VAR}
            echo -n "Node $i ($NODE_IP): "
            if curl -s http://$NODE_IP:8200/v1/sys/health > /dev/null 2>&1; then
                echo "✓ Healthy"
            else
                echo "✗ Unreachable"
            fi
        done
        ;;
    stop)
        echo "Stopping Vault cluster..."
        echo "Run these commands on each node:"
        echo ""
        echo "On Node 1: ./vault-node1-manage.sh stop"
        echo "On Node 2: ./vault-node2-manage.sh stop"
        echo "On Node 3: ./vault-node3-manage.sh stop"
        ;;
    *)
        echo "Usage: $0 {setup|start|init|status|stop}"
        echo ""
        echo "Commands:"
        echo "  setup   - Configure cluster with node IPs"
        echo "  start   - Start all nodes (run on each node)"
        echo "  init    - Initialize cluster (run on Node 1 first)"
        echo "  status  - Check cluster health"
        echo "  stop    - Stop all nodes (run on each node)"
        echo ""
        echo "IMPORTANT: Update IP addresses in this script first!"
        exit 1
        ;;
esac
