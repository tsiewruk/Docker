ui = true
disable_mlock = true
storage "raft" {
path = "./data" node_id = "vault.dev"
}
listener "tcp" {
address = "0.0.0.0:40404"
tls_disable = "true"
}
api_addr = "http://127.0.0.1:8200"
cluster_addr = "https://127.0.0.1:8201"