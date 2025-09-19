#!/bin/bash

# Vault Node 2 Management Script

NODE_IP="NODE2_IP"  # Zastąp rzeczywistym IP noda 2

case "$1" in
    start)
        echo "Starting Vault on Node 2..."
        # Zastąp NODE1_IP, NODE2_IP, NODE3_IP w konfiguracji
        sed -i "s/NODE1_IP/NODE1_IP/g" vault-configs/node2.hcl
        sed -i "s/NODE2_IP/$NODE_IP/g" vault-configs/node2.hcl
        sed -i "s/NODE3_IP/NODE3_IP/g" vault-configs/node2.hcl
        
        docker-compose -f vault-node2-compose.yml up -d
        echo "Vault Node 2 started on port 8200"
        ;;
    stop)
        echo "Stopping Vault on Node 2..."
        docker-compose -f vault-node2-compose.yml down
        ;;
    restart)
        echo "Restarting Vault on Node 2..."
        docker-compose -f vault-node2-compose.yml down
        docker-compose -f vault-node2-compose.yml up -d
        ;;
    status)
        echo "Vault Node 2 status:"
        docker-compose -f vault-node2-compose.yml ps
        echo ""
        echo -n "Health check: "
        if curl -s http://localhost:8200/v1/sys/health > /dev/null 2>&1; then
            echo "✓ Healthy"
        else
            echo "✗ Unhealthy"
        fi
        ;;
    logs)
        docker-compose -f vault-node2-compose.yml logs -f
        ;;
    unseal)
        if [ -f vault-node1-keys.txt ]; then
            KEY1=$(sed -n '1p' vault-node1-keys.txt)
            KEY2=$(sed -n '2p' vault-node1-keys.txt)
            docker exec vault-node2 vault operator unseal $KEY1
            docker exec vault-node2 vault operator unseal $KEY2
            echo "Vault Node 2 unsealed"
        else
            echo "Keys file not found. Copy vault-node1-keys.txt to this node first."
        fi
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|status|logs|unseal}"
        echo ""
        echo "Commands:"
        echo "  start   - Start Vault on Node 2"
        echo "  stop    - Stop Vault on Node 2"
        echo "  restart - Restart Vault on Node 2"
        echo "  status  - Show status and health"
        echo "  logs    - Show logs"
        echo "  unseal  - Unseal Vault using keys from Node 1"
        exit 1
        ;;
esac
