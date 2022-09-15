.DEFAULT_GOAL := help
DC_FILES=$(shell find . -type f -name "docker-compose.yml" -exec echo {} +)

help: ## Display help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

up: mongo roach keycloak monitor registry ## Start all containers in series

down: ## Take down all composed conatiners
	@for dc_file in $(DC_FILES); do\
		docker compose -f "$$dc_file" down;\
	done

clean: ## Remove all unused volumes and networks
	@./scripts/clean_docker.sh

cleanall: ## Remove all unused images, volumes and networks
	@./scripts/clean_docker.sh +i

reset: down clean ## Reset docker to blank state (Warning: Erase all data)

postgres: ## Starts PostgreSQL service
	@cd postgres && ./init.sh

mongo: ## Starts MongoDB service
	@cd mongo && ./init.sh

roach: ## Starts CockroachDB service
	@cd cockroachdb && ./init.sh

redis: ## Starts Redis service (Use --cluster option for cluster mode)
	@cd redis && ./init.sh

keycloak: ## Starts Keycloak service
	@cd keycloak && ./init.sh

monitor: ## Starts Monitoring service
	@cd monitor && docker compose up -d

registry: ## Starts Docker Registry
	@cd registry && ./init.sh --oauth

ca: ## Starts StepCA
	@cd stepca && ./init.sh

bootstrap: ## Bootstrap CA certificate in host machine
	@bash ./stepca/bootstrap_host.sh

docker-login: ## Login to local docker registry
	@docker logout localhost:21000
	@echo "Registry@123" | docker login localhost:21000 -u captain --password-stdin

.PHONY: help up down clean cleanall reset postgres mongo roach redis keycloak monitor registry ca bootstrap docker-login
