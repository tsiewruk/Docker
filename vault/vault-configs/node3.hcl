# Vault Node 3 Configuration (Follower)
ui = true
disable_mlock = true

# API server configuration
api_addr = "http://0.0.0.0:8200"
cluster_addr = "http://0.0.0.0:8201"

# Storage backend - Raft
storage "raft" {
  path = "/vault/data"
  node_id = "node3"
  
  # Adresy innych nodów w klastrze
  retry_join {
    leader_api_addr = "http://NODE1_IP:8200"
  }
  retry_join {
    leader_api_addr = "http://NODE2_IP:8200"
  }
  retry_join {
    leader_api_addr = "http://NODE3_IP:8200"
  }
}

# Listener configuration
listener "tcp" {
  address = "0.0.0.0:8200"
  cluster_address = "0.0.0.0:8201"
  tls_disable = true
}

# Seal configuration (for development)
seal "shamir" {
}

# Log level
log_level = "INFO"
