# Docker Infrastructure Project

## 📋 Overview
Comprehensive Docker-based infrastructure with **16 optimized services** built on **Ubuntu 24.04** with enhanced security, monitoring, and development capabilities.

**Project Status**: ✅ Production Ready | 🔒 Security Hardened | 📊 Fully Monitored

## 🏗️ Architecture

### Core Services (docker-compose.yml)
- **traefik** - Reverse proxy and load balancer
- **jenkins** - CI/CD automation server  
- **grafana** - Monitoring dashboards
- **prometheus** - Metrics collection
- **mysql** - Database server
- **rabbitmq** - Message broker
- **varnish** - HTTP accelerator
- **dev-container** - Development environment

### Specialized Stacks
- **WordPress Stack** (wordpress-compose.yml) - CMS with dedicated infrastructure
- **Monitoring Stack** (monitoring-compose.yml) - Complete observability suite
- **Security Stack** (wazuh-compose.yml) - SIEM and security monitoring

## 🚀 Quick Start

### Prerequisites
```bash
# Ensure Docker and Docker Compose are installed
docker --version
docker-compose --version
```

### Build and Deploy
```bash
# Build all services
docker-compose build

# Start main stack
docker-compose up -d

# Start specialized stacks (optional)
docker-compose -f wordpress-compose.yml up -d
docker-compose -f monitoring-compose.yml up -d
docker-compose -f wazuh-compose.yml up -d
```

### Service Management
```bash
# Check status
docker-compose ps

# View logs
docker-compose logs <service_name>

# Connect to container
docker-compose exec <service_name> bash

# Stop services
docker-compose down
```

## 🌐 Service Access

### Main Services
| Service | URL | Default Credentials |
|---------|-----|-------------------|
| Traefik Dashboard | http://localhost:8080 | - |
| Jenkins | http://localhost:8081 | admin/[secret] |
| Grafana | http://localhost:3000 | admin/[secret] |
| Prometheus | http://localhost:9090 | - |

### Monitoring Stack
| Service | URL | Purpose |
|---------|-----|---------|
| AlertManager | http://localhost:9093 | Alert management |
| Node Exporter | http://localhost:9100/metrics | System metrics |
| cAdvisor | http://localhost:8082 | Container metrics |

### Security Stack
| Service | URL | Purpose |
|---------|-----|---------|
| Wazuh Dashboard | http://localhost:5601 | Security monitoring |
| Wazuh API | http://localhost:55000 | Security API |

## 🔒 Security Features

### User Management Strategy
The project uses a **mixed user management approach**:

- **Main stack (docker-compose.yml)**: Uses Dockerfile USER directives
  - Containers run as `techuser` created during build
  - Consistent across environments, portable

- **Specialized stacks**: Uses `user: "1000:1000"` in compose files
  - Flexible host user mapping
  - Better file permissions alignment

### Security Measures Implemented
- ✅ **Non-root execution** - All services run as dedicated users
- ✅ **Docker Secrets** - Secure credential management
- ✅ **Network isolation** - Services separated into logical networks
- ✅ **Resource limits** - CPU/memory constraints prevent exhaustion
- ✅ **Health monitoring** - Continuous availability checks
- ✅ **Minimal capabilities** - No privileged containers
- ✅ **Security options** - `no-new-privileges` enabled

## 🛠️ Development

### Development Container Features
- **Languages**: Python 3.x
- **IaC Tools**: Terraform, OpenTofu, Ansible
- **Cloud Tools**: Azure CLI, Helm
- **Development**: Git, SSH, pre-commit hooks
- **Linting**: YAML-lint, JSON-lint

### Access Development Environment
```bash
# Start and connect to dev container
docker-compose up -d dev-container
docker-compose exec dev-container bash
```

### User Security Audit
```bash
# Check which containers run as root
docker-compose exec <service> whoami

# Verify user configuration
docker-compose exec <service> id

# Check file permissions
docker-compose exec <service> ls -la /var/log
```

## 📁 Project Structure

```
├── builders/                 # Optimized Dockerfile definitions
│   ├── ubuntu-base/         # Foundation image (Ubuntu 24.04)
│   ├── jenkins/             # CI/CD server
│   ├── grafana/             # Monitoring dashboard
│   ├── prometheus/          # Metrics collector
│   └── ...                  # Other service builders
├── cookbooks/               # Reusable installation scripts
│   ├── installers/          # Software installation
│   └── setters/             # Configuration scripts
├── secrets/                 # Secure credential management
├── docker-compose.yml       # Main service stack
├── wordpress-compose.yml    # WordPress stack
├── monitoring-compose.yml   # Monitoring stack
└── wazuh-compose.yml       # Security stack
```

## 📋 Troubleshooting

### Common Issues
1. **Port conflicts**: Check port mappings in compose files
2. **Permission errors**: Verify volume mount permissions
3. **Health check failures**: Check service logs and endpoints
4. **Resource limits**: Monitor CPU/memory usage with `docker stats`

### Debug Commands
```bash
# Check container resource usage
docker stats

# Inspect container configuration
docker inspect <container_name>

# View detailed logs
docker-compose logs --details <service_name>

# Check network connectivity
docker network ls
docker network inspect <network_name>
```

## 📚 Technical Details

### Version Information
- **Base OS**: Ubuntu 24.04 LTS
- **Docker Compose**: v2.x
- **Security Level**: Enterprise-grade
- **Monitoring**: Full observability stack
- **Development**: Complete DevOps toolchain

### Port Mapping Summary
| Service | Internal | External | Notes |
|---------|----------|----------|-------|
| Traefik | 80,443,8080 | 80,443,8080 | Reverse proxy |
| Jenkins | 8080 | 8081 | Conflict resolved |
| Grafana | 3000 | 3000 | Monitoring |
| WordPress | 80,443 | 8083,8443 | Conflict resolved |
| cAdvisor | 8080 | 8082 | Conflict resolved |

---

For detailed configuration and advanced usage, see the individual compose files and builder directories.
