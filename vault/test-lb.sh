#!/bin/bash

# Load Balancer Test Script

NODE1_IP="NODE1_IP"  # Zastąp rzeczywistym IP noda 1

echo "Testing Vault Load Balancer..."
echo "================================"

# Test 1: Health check
echo "1. Testing health check endpoint:"
curl -s http://$NODE1_IP:8206/health | jq '.' 2>/dev/null || curl -s http://$NODE1_IP:8206/health
echo ""

# Test 2: Load balancer distribution
echo "2. Testing load balancer distribution:"
for i in {1..10}; do
    echo -n "Request $i: "
    curl -s http://$NODE1_IP:8206/v1/sys/health | jq -r '.leader' 2>/dev/null || echo "Failed"
    sleep 1
done

# Test 3: Direct node access
echo ""
echo "3. Testing direct node access:"
echo "Node 1: $(curl -s http://$NODE1_IP:8200/v1/sys/health | jq -r '.leader' 2>/dev/null || echo 'Failed')"
echo "Node 2: $(curl -s http://NODE2_IP:8200/v1/sys/health | jq -r '.leader' 2>/dev/null || echo 'Failed')"
echo "Node 3: $(curl -s http://NODE3_IP:8200/v1/sys/health | jq -r '.leader' 2>/dev/null || echo 'Failed')"

# Test 4: Failover test
echo ""
echo "4. Testing failover (stop Node 2 and Node 3):"
echo "   This test requires manual intervention:"
echo "   - Stop Node 2: ./vault-manage.sh node2 stop"
echo "   - Stop Node 3: ./vault-manage.sh node3 stop"
echo "   - Test LB: curl http://$NODE1_IP:8206/health"

echo ""
echo "Load Balancer test completed!"

