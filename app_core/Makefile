# Helper function to install a tool if not present
define install-tool
	@if ! command -v $(1) &> /dev/null; then \
		echo "Installing $(1)..."; \
		if [[ "$$OSTYPE" == "darwin"* ]]; then \
			brew install $(1); \
		elif [[ "$$OSTYPE" == "linux-gnu"* ]]; then \
			sudo apt-get update && sudo apt-get install -y $(1); \
		else \
			echo "Please install $(1) manually: $(2)"; \
		fi; \
	else \
		echo "$(1) is already installed"; \
	fi
endef

generate-dev:
	jsonnet docker-compose.jsonnet -V ENV=development | yq eval -P > docker-compose.dev.yml

generate-prod:
	jsonnet docker-compose.jsonnet -V ENV=production | yq eval -P > docker-compose.prod.yml

# Development commands
dev: generate-dev
	docker-compose -p multitenant-core -f docker-compose.dev.yml up --build

dev-detached: generate-dev
	docker-compose -p multitenant-core -f docker-compose.dev.yml up -d --build

dev-logs:
	docker-compose -p multitenant-core -f docker-compose.dev.yml logs -f backend

dev-stop:
	docker-compose -p multitenant-core -f docker-compose.dev.yml down

# Production commands
prod: generate-prod
	docker-compose -p multitenant-core -f docker-compose.prod.yml up --build

prod-detached: generate-prod
	docker-compose -p multitenant-core -f docker-compose.prod.yml up -d --build

prod-stop:
	docker-compose -p multitenant-core -f docker-compose.prod.yml down

# Install dependencies
install-deps:
	$(call install-tool,jsonnet,https://jsonnet.org/)
	$(call install-tool,yq,https://github.com/mikefarah/yq)