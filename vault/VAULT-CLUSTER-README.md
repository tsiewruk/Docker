# Vault Cluster - 3 Nody

Ta konfiguracja uruchamia klaster HashiCorp Vault na 3 osobnych nodach - po jednym Vault na każdym nodzie.

## Struktura

- **Node 1**: Vault Leader - port 8200
- **Node 2**: Vault Follower - port 8200  
- **Node 3**: Vault Follower - port 8200

Każdy nod ma swój własny Docker Compose i konfigurację.

## Pliki

### Konfiguracje Docker Compose
- `vault-node1-compose.yml` - Konfiguracja dla noda 1
- `vault-node2-compose.yml` - Konfiguracja dla noda 2
- `vault-node3-compose.yml` - Konfiguracja dla noda 3

### Skrypty zarządzania
- `vault-node1-manage.sh` - Zarządzanie nodem 1
- `vault-node2-manage.sh` - Zarządzanie nodem 2
- `vault-node3-manage.sh` - Zarządzanie nodem 3
- `vault-cluster-manage.sh` - Zarządzanie całym klastrem

### Konfiguracje Vault
- `vault-configs/node1.hcl` - Konfiguracja Vault dla noda 1
- `vault-configs/node2.hcl` - Konfiguracja Vault dla noda 2
- `vault-configs/node3.hcl` - Konfiguracja Vault dla noda 3

## Instalacja

### 1. Przygotowanie

```bash
# Skonfiguruj IP nodów w skrypcie
nano vault-cluster-manage.sh
# Zastąp NODE1_IP, NODE2_IP, NODE3_IP rzeczywistymi adresami IP

# Uruchom konfigurację
./vault-cluster-manage.sh setup
```

### 2. Kopiowanie plików na nody

**Na Node 1:**
```bash
# Skopiuj te pliki na Node 1:
- vault-node1-compose.yml
- vault-node1-manage.sh
- vault-configs/node1.hcl
```

**Na Node 2:**
```bash
# Skopiuj te pliki na Node 2:
- vault-node2-compose.yml
- vault-node2-manage.sh
- vault-configs/node2.hcl
```

**Na Node 3:**
```bash
# Skopiuj te pliki na Node 3:
- vault-node3-compose.yml
- vault-node3-manage.sh
- vault-configs/node3.hcl
```

### 3. Uruchomienie klastra

**Krok 1: Uruchom wszystkie nody**
```bash
# Na każdym nodzie:
./vault-node1-manage.sh start  # Node 1
./vault-node2-manage.sh start  # Node 2
./vault-node3-manage.sh start  # Node 3
```

**Krok 2: Zainicjalizuj klaster (tylko na Node 1)**
```bash
# Na Node 1:
./vault-node1-manage.sh init
```

**Krok 3: Skopiuj klucze na inne nody**
```bash
# Skopiuj vault-node1-keys.txt na Node 2 i Node 3
```

**Krok 4: Unseal wszystkie nody**
```bash
# Na każdym nodzie:
./vault-node1-manage.sh unseal  # Node 1
./vault-node2-manage.sh unseal  # Node 2
./vault-node3-manage.sh unseal  # Node 3
```

## Zarządzanie

### Sprawdzenie statusu
```bash
# Sprawdź status całego klastra
./vault-cluster-manage.sh status

# Sprawdź status konkretnego noda
./vault-node1-manage.sh status  # Na Node 1
```

### Logi
```bash
# Zobacz logi konkretnego noda
./vault-node1-manage.sh logs  # Na Node 1
```

### Zatrzymanie
```bash
# Zatrzymaj konkretny nod
./vault-node1-manage.sh stop  # Na Node 1

# Zatrzymaj cały klaster
./vault-cluster-manage.sh stop  # Uruchom na każdym nodzie
```

## Dostęp

- **Node 1**: http://NODE1_IP:8200
- **Node 2**: http://NODE2_IP:8200
- **Node 3**: http://NODE3_IP:8200

## Konfiguracja sieci

Upewnij się, że:
1. Wszystkie nody mogą się komunikować na porcie 8200 i 8201
2. Firewall pozwala na komunikację między nodami
3. IP adresy są statyczne lub mają rezerwację DHCP

## Bezpieczeństwo

- Konfiguracja w trybie development (TLS wyłączone)
- Shamir seal (3 klucze, wymagane 2 do unseal)
- Root token generowany podczas inicjalizacji

## Troubleshooting

### Problem z komunikacją między nodami
1. Sprawdź IP adresy w konfiguracjach
2. Sprawdź firewall i sieć
3. Sprawdź logi: `./vault-node1-manage.sh logs`

### Problem z unseal
1. Upewnij się, że klucze są skopiowane na wszystkie nody
2. Sprawdź czy Vault jest uruchomiony na wszystkich nodach
3. Sprawdź logi błędów

### Problem z inicjalizacją
1. Upewnij się, że wszystkie nody są uruchomione
2. Sprawdź czy porty 8200 i 8201 są dostępne
3. Sprawdź konfigurację Raft storage
