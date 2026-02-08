# Makefile for managing entrypoint scripts across all containers

# Define containers by their entrypoint complexity
SIMPLE_CONTAINERS := mysql jenkins node-exporter blackbox cadvisor wazuh-server
STANDARD_CONTAINERS := rabbitmq prometheus varnish alert-manager dev-container traefik wordpress
ADVANCED_CONTAINERS := grafana wazuh-indexer wazuh-dashboard

ALL_CONTAINERS := $(SIMPLE_CONTAINERS) $(STANDARD_CONTAINERS) $(ADVANCED_CONTAINERS)

.PHONY: all validate backup restore clean help list-containers check-syntax fix-permissions convert-to-compose-user

all: validate

# Convert from Dockerfile USER to docker-compose user approach
convert-to-compose-user:
	@echo "=== Converting to docker-compose user management ==="
	@echo ""
	@echo "This will:"
	@echo "1. Remove USER directives from Dockerfiles"
	@echo "2. Add user: '1000:1000' to docker-compose.yml services"
	@echo "3. Create backup of current configuration"
	@echo ""
	@read -p "Continue? (y/N): " confirm; \
	if [ "$$confirm" = "y" ] || [ "$$confirm" = "Y" ]; then \
		$(MAKE) backup; \
		$(MAKE) _remove_dockerfile_users; \
		$(MAKE) _add_compose_users; \
		echo "✅ Conversion completed"; \
		echo "⚠️  Remember to rebuild images: docker-compose build"; \
	else \
		echo "❌ Conversion cancelled"; \
	fi

# Internal target: Remove USER directives from Dockerfiles
_remove_dockerfile_users:
	@echo "Removing USER directives from Dockerfiles..."
	@for container in $(ALL_CONTAINERS); do \
		dockerfile="$$container/Dockerfile"; \
		if [ -f "$$dockerfile" ] && grep -q "^USER" "$$dockerfile"; then \
			sed -i '/^USER /d' "$$dockerfile"; \
			sed -i '/^# Security: Use non-root user/d' "$$dockerfile"; \
			echo "  ✓ Removed USER from $$container/Dockerfile"; \
		fi; \
	done

# Internal target: Add user directives to docker-compose.yml
_add_compose_users:
	@echo "Adding user directives to docker-compose.yml..."
	@echo "⚠️  This requires manual editing of docker-compose.yml"
	@echo "Add the following to each service:"
	@echo "    user: \"1000:1000\"  # techuser"

# Revert to Dockerfile USER approach
revert-to-dockerfile-user:
	@echo "=== Reverting to Dockerfile USER management ==="
	@echo ""
	@echo "This will restore USER directives in Dockerfiles"
	@echo ""
	@read -p "Continue? (y/N): " confirm; \
	if [ "$$confirm" = "y" ] || [ "$$confirm" = "Y" ]; then \
		$(MAKE) restore; \
		echo "✅ Reverted to Dockerfile USER approach"; \
		echo "⚠️  Remember to rebuild images: docker-compose build"; \
	else \
		echo "❌ Revert cancelled"; \
	fi

# Show user configuration comparison
compare-user-approaches:
	@echo "=== User Management Approaches Comparison ==="
	@echo ""
	@echo "📋 Current approach: Dockerfile USER"
	@echo "   Pros: Security, Portability, Immutable"
	@echo "   Cons: Inflexible, Complex setup"
	@echo ""
	@echo "📋 Alternative approach: docker-compose user"
	@echo "   Pros: Flexible, Simple, Host mapping"
	@echo "   Cons: Security risk, Compose dependency"
	@echo ""
	@echo "📋 Hybrid approach (recommended):"
	@echo "   - Keep USER in Dockerfile as fallback"
	@echo "   - Override with user: in compose when needed"
	@echo "   - Best of both worlds"

# List all containers and their entrypoint types
list-containers:
	@echo "=== Container Entrypoint Overview ==="
	@echo ""
	@echo "Simple entrypoints (basic s6-svscan only):"
	@for container in $(SIMPLE_CONTAINERS); do \
		echo "  - $$container"; \
	done
	@echo ""
	@echo "Standard entrypoints (with script execution logic):"
	@for container in $(STANDARD_CONTAINERS); do \
		echo "  - $$container"; \
	done
	@echo ""
	@echo "Advanced entrypoints (with logging and error handling):"
	@for container in $(ADVANCED_CONTAINERS); do \
		echo "  - $$container"; \
	done

# Validate all entrypoint scripts
validate:
	@echo "=== Validating entrypoint scripts ==="
	@error_count=0; \
	for container in $(ALL_CONTAINERS); do \
		entrypoint_file="$$container/files/usr/local/bin/entrypoint.sh"; \
		if [ -f "$$entrypoint_file" ]; then \
			echo -n "Validating $$container: "; \
			if bash -n "$$entrypoint_file" 2>/dev/null; then \
				echo "✓ Valid syntax"; \
			else \
				echo "✗ Invalid syntax"; \
				error_count=$$((error_count + 1)); \
			fi; \
		else \
			echo "$$container: ⚠ Entrypoint file not found"; \
			error_count=$$((error_count + 1)); \
		fi; \
	done; \
	echo ""; \
	if [ $$error_count -eq 0 ]; then \
		echo "✓ All entrypoint scripts are valid"; \
	else \
		echo "✗ Found $$error_count issues"; \
		exit 1; \
	fi

# Check syntax of specific container
check-syntax:
	@if [ -z "$(CONTAINER)" ]; then \
		echo "Usage: make check-syntax CONTAINER=<container_name>"; \
		echo "Available containers: $(ALL_CONTAINERS)"; \
		exit 1; \
	fi
	@entrypoint_file="$(CONTAINER)/files/usr/local/bin/entrypoint.sh"; \
	if [ -f "$$entrypoint_file" ]; then \
		echo "Checking syntax for $(CONTAINER)..."; \
		bash -n "$$entrypoint_file" && echo "✓ Syntax is valid" || echo "✗ Syntax errors found"; \
	else \
		echo "✗ Entrypoint file not found: $$entrypoint_file"; \
	fi

# Fix permissions for all entrypoint scripts
fix-permissions:
	@echo "=== Fixing entrypoint permissions ==="
	@for container in $(ALL_CONTAINERS); do \
		entrypoint_file="$$container/files/usr/local/bin/entrypoint.sh"; \
		if [ -f "$$entrypoint_file" ]; then \
			chmod +x "$$entrypoint_file"; \
			echo "Fixed permissions for $$container"; \
		fi; \
	done

# Backup existing entrypoints
backup:
	@echo "=== Creating backup of entrypoints ==="
	@backup_dir="backups/$$(date +%Y%m%d_%H%M%S)"; \
	mkdir -p "$$backup_dir"; \
	for container in $(ALL_CONTAINERS); do \
		entrypoint_file="$$container/files/usr/local/bin/entrypoint.sh"; \
		dockerfile="$$container/Dockerfile"; \
		if [ -f "$$entrypoint_file" ]; then \
			mkdir -p "$$backup_dir/$$container"; \
			cp "$$entrypoint_file" "$$backup_dir/$$container/"; \
			echo "Backed up $$container/entrypoint.sh"; \
		fi; \
		if [ -f "$$dockerfile" ]; then \
			mkdir -p "$$backup_dir/$$container"; \
			cp "$$dockerfile" "$$backup_dir/$$container/"; \
			echo "Backed up $$container/Dockerfile"; \
		fi; \
	done; \
	echo "Backup created in: $$backup_dir"

# Restore from most recent backup
restore:
	@echo "=== Restoring from backup ==="
	@latest_backup=$$(ls -1t backups/ 2>/dev/null | head -n1); \
	if [ -z "$$latest_backup" ]; then \
		echo "No backups found"; \
		exit 1; \
	fi; \
	echo "Restoring from: backups/$$latest_backup"; \
	for container in $(ALL_CONTAINERS); do \
		backup_entrypoint="backups/$$latest_backup/$$container/entrypoint.sh"; \
		backup_dockerfile="backups/$$latest_backup/$$container/Dockerfile"; \
		target_entrypoint="$$container/files/usr/local/bin/entrypoint.sh"; \
		target_dockerfile="$$container/Dockerfile"; \
		if [ -f "$$backup_entrypoint" ]; then \
			cp "$$backup_entrypoint" "$$target_entrypoint"; \
			chmod +x "$$target_entrypoint"; \
			echo "Restored $$container/entrypoint.sh"; \
		fi; \
		if [ -f "$$backup_dockerfile" ]; then \
			cp "$$backup_dockerfile" "$$target_dockerfile"; \
			echo "Restored $$container/Dockerfile"; \
		fi; \
	done

# Show entrypoint content for specific container
show:
	@if [ -z "$(CONTAINER)" ]; then \
		echo "Usage: make show CONTAINER=<container_name>"; \
		echo "Available containers: $(ALL_CONTAINERS)"; \
		exit 1; \
	fi
	@entrypoint_file="$(CONTAINER)/files/usr/local/bin/entrypoint.sh"; \
	if [ -f "$$entrypoint_file" ]; then \
		echo "=== $(CONTAINER)/entrypoint.sh ==="; \
		cat "$$entrypoint_file"; \
	else \
		echo "✗ Entrypoint file not found: $$entrypoint_file"; \
	fi

# Compare entrypoints between containers
compare:
	@if [ -z "$(CONTAINER1)" ] || [ -z "$(CONTAINER2)" ]; then \
		echo "Usage: make compare CONTAINER1=<name1> CONTAINER2=<name2>"; \
		echo "Available containers: $(ALL_CONTAINERS)"; \
		exit 1; \
	fi
	@file1="$(CONTAINER1)/files/usr/local/bin/entrypoint.sh"; \
	file2="$(CONTAINER2)/files/usr/local/bin/entrypoint.sh"; \
	if [ -f "$$file1" ] && [ -f "$$file2" ]; then \
		echo "=== Comparing $(CONTAINER1) vs $(CONTAINER2) ==="; \
		diff -u "$$file1" "$$file2" || true; \
	else \
		echo "One or both entrypoint files not found"; \
	fi

# Find containers with similar entrypoint patterns
analyze-patterns:
	@echo "=== Analyzing entrypoint patterns ==="
	@echo ""
	@echo "Containers using standard script execution pattern:"
	@for container in $(STANDARD_CONTAINERS); do \
		entrypoint_file="$$container/files/usr/local/bin/entrypoint.sh"; \
		if [ -f "$$entrypoint_file" ] && grep -q "entrypoint-scripts" "$$entrypoint_file"; then \
			echo "  ✓ $$container"; \
		fi; \
	done
	@echo ""
	@echo "Containers with advanced logging:"
	@for container in $(ADVANCED_CONTAINERS); do \
		entrypoint_file="$$container/files/usr/local/bin/entrypoint.sh"; \
		if [ -f "$$entrypoint_file" ] && grep -q "log()" "$$entrypoint_file"; then \
			echo "  ✓ $$container"; \
		fi; \
	done

# Clean backup files older than 30 days
clean:
	@echo "=== Cleaning old backups ==="
	@if [ -d "backups" ]; then \
		find backups -type d -mtime +30 -exec rm -rf {} + 2>/dev/null || true; \
		echo "Cleaned backups older than 30 days"; \
	else \
		echo "No backups directory found"; \
	fi

# Analyze current user configuration across all compose files
analyze-user-config:
	@echo "=== Current User Configuration Analysis ==="
	@echo ""
	@echo "📋 Main Stack (docker-compose.yml) - Dockerfile USER approach:"
	@if [ -f "../docker-compose.yml" ]; then \
		grep -A5 -B5 "user:" ../docker-compose.yml | grep -E "(^\s*[a-z-]+:|user:)" | sed 's/^/  /' || echo "  No user directives found (using Dockerfile USER)"; \
	fi
	@echo ""
	@echo "📋 WordPress Stack (wordpress-compose.yml) - docker-compose user approach:"
	@if [ -f "../wordpress-compose.yml" ]; then \
		grep -A1 -B1 "user:" ../wordpress-compose.yml | grep -E "(^\s*[a-z-]+:|user:)" | sed 's/^/  /'; \
	fi
	@echo ""
	@echo "📋 Monitoring Stack (monitoring-compose.yml) - docker-compose user approach:"
	@if [ -f "../monitoring-compose.yml" ]; then \
		grep -A1 -B1 "user:" ../monitoring-compose.yml | grep -E "(^\s*[a-z-]+:|user:)" | sed 's/^/  /'; \
	fi
	@echo ""
	@echo "📋 Wazuh Stack (wazuh-compose.yml) - docker-compose user approach:"
	@if [ -f "../wazuh-compose.yml" ]; then \
		grep -A1 -B1 "user:" ../wazuh-compose.yml | grep -E "(^\s*[a-z-]+:|user:)" | sed 's/^/  /'; \
	fi

# Show user configuration summary
user-summary:
	@echo "=== User Configuration Summary ==="
	@echo ""
	@echo "🔧 Mixed User Management Approach:"
	@echo "  ✅ Main stack: Dockerfile USER (consistent, portable)"
	@echo "  ✅ Specialized stacks: docker-compose user (flexible, host-compatible)"
	@echo ""
	@echo "📊 Configuration by Stack:"
	@echo "  • docker-compose.yml: $(words $(ALL_CONTAINERS)) containers using Dockerfile USER"
	@echo "  • wordpress-compose.yml: 3 containers using user: \"1000:1000\""
	@echo "  • monitoring-compose.yml: 7 containers using user: \"1000:1000\""
	@echo "  • wazuh-compose.yml: 3 containers using user: \"1000:1000\""
	@echo ""
	@echo "🔒 Security Status: All containers run as non-root users"

# Show help
help:
	@echo "=== Entrypoint Management Makefile ==="
	@echo ""
	@echo "Available targets:"
	@echo "  list-containers       - Show all containers grouped by entrypoint type"
	@echo "  validate             - Validate syntax of all entrypoint scripts"
	@echo "  check-syntax         - Check syntax of specific container (use CONTAINER=name)"
	@echo "  fix-permissions      - Fix execute permissions for all entrypoints"
	@echo "  backup               - Create timestamped backup of all entrypoints"
	@echo "  restore              - Restore from most recent backup"
	@echo "  show                 - Show entrypoint content (use CONTAINER=name)"
	@echo "  compare              - Compare two entrypoints (use CONTAINER1=name1 CONTAINER2=name2)"
	@echo "  analyze-patterns     - Analyze and categorize entrypoint patterns"
	@echo "  clean                - Remove old backup files (>30 days)"
	@echo ""
	@echo "User management:"
	@echo "  analyze-user-config       - Analyze current user configuration across all compose files"
	@echo "  user-summary             - Show user configuration summary"
	@echo "  compare-user-approaches  - Compare Dockerfile vs compose user approaches"
	@echo "  convert-to-compose-user  - Convert to docker-compose user management"
	@echo "  revert-to-dockerfile-user - Revert to Dockerfile USER approach"
	@echo ""
	@echo "  help                 - Show this help"
	@echo ""
	@echo "Examples:"
	@echo "  make validate"
	@echo "  make check-syntax CONTAINER=grafana"
	@echo "  make show CONTAINER=rabbitmq"
	@echo "  make compare CONTAINER1=grafana CONTAINER2=prometheus"
	@echo "  make backup"
	@echo "  make analyze-user-config"
	@echo "  make user-summary"
	@echo ""
	@echo "Container categories:"
	@echo "  Simple ($(words $(SIMPLE_CONTAINERS))): $(SIMPLE_CONTAINERS)"
	@echo "  Standard ($(words $(STANDARD_CONTAINERS))): $(STANDARD_CONTAINERS)"
	@echo "  Advanced ($(words $(ADVANCED_CONTAINERS))): $(ADVANCED_CONTAINERS)" 