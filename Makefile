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
	@cd postgres && ./init.sh -f

mongo: ## Starts MongoDB service
	@cd mongo && ./init.sh

roach: ## Starts CockroachDB service
	@cd cockroachdb && ./init.sh

redis: ## Starts Redis service
	@cd redis && ./init.sh

keycloak: ## Starts Keycloak service
	@cd keycloak && ./init.sh -f

monitor: ## Starts Monitoring service
	@cd monitor && docker compose up -d

registry: redis ## Starts Docker Registry
	@cd registry && ../scripts/step_certs_renew.sh && ./init.sh

ca: ## Starts StepCA
	@cd stepca && ./init.sh

rootca: ## Display Root CA Certificate
	@docker exec ca cat /home/step/certs/root_ca.crt

.PHONY: help up down clean cleanall reset postgres mongo roach redis keycloak monitor registry ca rootca
