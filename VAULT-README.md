# Vault Cluster - 3 Nody

Kompletna konfiguracja HashiCorp Vault w klastrze na 3 nodach.

## 📁 Struktura projektu

```text
vault/
├── vault-cluster-manage.sh     # Zarządzanie całym klastrem
├── vault-configs/              # Konfiguracje Vault
│   ├── node1.hcl              # Konfiguracja dla noda 1
│   ├── node2.hcl              # Konfiguracja dla noda 2
│   └── node3.hcl              # Konfiguracja dla noda 3
├── vault-node1-compose.yml     # Docker Compose dla noda 1
├── vault-node1-manage.sh       # Zarządzanie nodem 1
├── vault-node2-compose.yml     # Docker Compose dla noda 2
├── vault-node2-manage.sh       # Zarządzanie nodem 2
├── vault-node3-compose.yml     # Docker Compose dla noda 3
├── vault-node3-manage.sh       # Zarządzanie nodem 3
└── VAULT-CLUSTER-README.md     # Dokumentacja klastra
```

## 🚀 Szybki start

### 1. Konfiguracja

```bash
# Edytuj IP nodów
nano vault/vault-cluster-manage.sh

# Uruchom konfigurację
./vault-manage.sh cluster setup
```

### 2. Kopiowanie na nody

Skopiuj odpowiednie pliki na każdy nod:

- **Node 1**: `vault-node1-compose.yml`, `vault-node1-manage.sh`, `vault-configs/node1.hcl`
- **Node 2**: `vault-node2-compose.yml`, `vault-node2-manage.sh`, `vault-configs/node2.hcl`
- **Node 3**: `vault-node3-compose.yml`, `vault-node3-manage.sh`, `vault-configs/node3.hcl`

### 3. Uruchomienie

```bash
# Uruchom wszystkie nody
./vault-manage.sh cluster start

# Zainicjalizuj klaster (tylko na Node 1)
./vault-manage.sh node1 init

# Unseal wszystkich nodów
./vault-manage.sh node1 unseal
./vault-manage.sh node2 unseal
./vault-manage.sh node3 unseal
```

## 📋 Dostępne komendy

### Zarządzanie klastrem

```bash
./vault-manage.sh cluster setup    # Konfiguracja
./vault-manage.sh cluster start    # Uruchomienie
./vault-manage.sh cluster init     # Inicjalizacja
./vault-manage.sh cluster status   # Status
./vault-manage.sh cluster stop     # Zatrzymanie
```

### Zarządzanie nodami

```bash
./vault-manage.sh node1 start      # Uruchom Node 1
./vault-manage.sh node1 stop       # Zatrzymaj Node 1
./vault-manage.sh node1 status     # Status Node 1
./vault-manage.sh node1 init       # Inicjalizuj Node 1
./vault-manage.sh node1 unseal     # Unseal Node 1
```

## 🌐 Dostęp

- **Load Balancer**: `http://NODE1_IP:8206` (zalecane)
- **Node 1**: `http://NODE1_IP:8200`
- **Node 2**: `http://NODE2_IP:8200`
- **Node 3**: `http://NODE3_IP:8200`

## 📚 Dokumentacja

- `vault/VAULT-CLUSTER-README.md` - Szczegółowa dokumentacja klastra

## ⚙️ Konfiguracja

Przed uruchomieniem zaktualizuj IP adresy w:

- `vault/vault-cluster-manage.sh` - Główna konfiguracja IP
- `vault/vault-node1-manage.sh` - IP noda 1
- `vault/vault-node2-manage.sh` - IP noda 2
- `vault/vault-node3-manage.sh` - IP noda 3

## 🔧 Troubleshooting

1. **Problem z komunikacją**: Sprawdź IP adresy i firewall
2. **Problem z unseal**: Upewnij się, że klucze są skopiowane na wszystkie nody
3. **Problem z inicjalizacją**: Sprawdź czy wszystkie nody są uruchomione

## 📝 Uwagi

- Konfiguracja w trybie development (TLS wyłączone)
- Shamir seal (3 klucze, wymagane 2 do unseal)
- Raft storage backend dla wysokiej dostępności
- Automatyczne failover między nodami
