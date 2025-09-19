#!/bin/bash

# Main Vault Management Script
# This script runs vault management commands from the vault directory

cd "$(dirname "$0")/vault"

case "$1" in
    cluster)
        shift
        ./vault-cluster-manage.sh "$@"
        ;;
    node1)
        shift
        ./vault-node1-manage.sh "$@"
        ;;
    node2)
        shift
        ./vault-node2-manage.sh "$@"
        ;;
    node3)
        shift
        ./vault-node3-manage.sh "$@"
        ;;
    *)
        echo "Vault Management Script"
        echo ""
        echo "Usage: $0 {cluster|node1|node2|node3} [command]"
        echo ""
        echo "Commands:"
        echo "  cluster setup    - Configure cluster with node IPs"
        echo "  cluster start    - Start all nodes"
        echo "  cluster init     - Initialize cluster"
        echo "  cluster status   - Check cluster health"
        echo "  cluster stop     - Stop all nodes"
        echo ""
        echo "  node1 start      - Start Vault + LB on Node 1"
        echo "  node1 stop       - Stop Vault + LB on Node 1"
        echo "  node1 status     - Check Node 1 + LB status"
        echo "  node1 init       - Initialize Node 1"
        echo "  node1 unseal     - Unseal Node 1"
        echo ""
        echo "  node2 start      - Start Vault on Node 2"
        echo "  node2 stop       - Stop Vault on Node 2"
        echo "  node2 status     - Check Node 2 status"
        echo "  node2 unseal     - Unseal Node 2"
        echo ""
        echo "  node3 start      - Start Vault on Node 3"
        echo "  node3 stop       - Stop Vault on Node 3"
        echo "  node3 status     - Check Node 3 status"
        echo "  node3 unseal     - Unseal Node 3"
        echo ""
        echo "Examples:"
        echo "  $0 cluster setup"
        echo "  $0 node1 start"
        echo "  $0 node1 init"
        echo "  $0 cluster status"
        exit 1
        ;;
esac