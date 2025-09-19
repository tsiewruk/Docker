#!/bin/bash

# Vault Node 1 Management Script

NODE_IP="NODE1_IP"  # Zastąp rzeczywistym IP noda 1

case "$1" in
    start)
        echo "Starting Vault on Node 1 with Load Balancer..."
        # Zastąp NODE1_IP, NODE2_IP, NODE3_IP w konfiguracji
        sed -i "s/NODE1_IP/$NODE_IP/g" vault-configs/node1.hcl
        sed -i "s/NODE2_IP/NODE2_IP/g" vault-configs/node1.hcl
        sed -i "s/NODE3_IP/NODE3_IP/g" vault-configs/node1.hcl
        
        # Zastąp IP w konfiguracji nginx
        sed -i "s/NODE2_IP/NODE2_IP/g" vault-configs/nginx-lb.conf
        sed -i "s/NODE3_IP/NODE3_IP/g" vault-configs/nginx-lb.conf
        
        docker-compose -f vault-node1-compose.yml up -d
        echo "Vault Node 1 started on port 8200"
        echo "Load Balancer started on port 8206"
        ;;
    stop)
        echo "Stopping Vault on Node 1..."
        docker-compose -f vault-node1-compose.yml down
        ;;
    restart)
        echo "Restarting Vault on Node 1..."
        docker-compose -f vault-node1-compose.yml down
        docker-compose -f vault-node1-compose.yml up -d
        ;;
    status)
        echo "Vault Node 1 status:"
        docker-compose -f vault-node1-compose.yml ps
        echo ""
        echo -n "Vault health check: "
        if curl -s http://localhost:8200/v1/sys/health > /dev/null 2>&1; then
            echo "✓ Healthy"
        else
            echo "✗ Unhealthy"
        fi
        echo -n "Load Balancer health check: "
        if curl -s http://localhost:8206/health > /dev/null 2>&1; then
            echo "✓ Healthy"
        else
            echo "✗ Unhealthy"
        fi
        ;;
    logs)
        docker-compose -f vault-node1-compose.yml logs -f
        ;;
    init)
        echo "Initializing Vault on Node 1..."
        sleep 5
        INIT_OUTPUT=$(docker exec vault-node1 vault operator init -key-shares=3 -key-threshold=2 -format=json)
        echo $INIT_OUTPUT | jq -r '.root_token' > vault-node1-token.txt
        echo $INIT_OUTPUT | jq -r '.unseal_keys_b64[]' > vault-node1-keys.txt
        echo "Vault Node 1 initialized. Token and keys saved to files."
        ;;
    unseal)
        if [ -f vault-node1-keys.txt ]; then
            KEY1=$(sed -n '1p' vault-node1-keys.txt)
            KEY2=$(sed -n '2p' vault-node1-keys.txt)
            docker exec vault-node1 vault operator unseal $KEY1
            docker exec vault-node1 vault operator unseal $KEY2
            echo "Vault Node 1 unsealed"
        else
            echo "Keys file not found. Run 'init' first."
        fi
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|status|logs|init|unseal}"
        echo ""
        echo "Commands:"
        echo "  start   - Start Vault on Node 1"
        echo "  stop    - Stop Vault on Node 1"
        echo "  restart - Restart Vault on Node 1"
        echo "  status  - Show status and health"
        echo "  logs    - Show logs"
        echo "  init    - Initialize Vault (first time only)"
        echo "  unseal  - Unseal Vault"
        exit 1
        ;;
esac
