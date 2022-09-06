help: ## Display help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help
DC_FILES=$(shell find . -type f -name "docker-compose.yml" -exec echo {} +)

up: postgres mongo roach redis keyclock monitor ## Start all containers in series

qup: ## Start all containers in parallel
	@make postgres 2>&1 ||:
	@(make mongo 2>&1 ||:) &
	@(make roach 2>&1 ||:) &
	@(make redis 2>&1 ||:) &
	@(make keyclock 2>&1 ||:) &
	@(make monitor 2>&1 ||:) &

down: ## Take down all composed conatiners
	@for dc_file in $(DC_FILES); do\
		docker compose -f "$$dc_file" down;\
	done

clean: ## Remove all unused volumes and networks
	@./scripts/clean_docker.sh

cleanall: ## Remove all unused images, volumes and networks
	@./scripts/clean_docker.sh +i

reset: down cleanall ## Reset docker to blank state (Warning: Erase all data)

postgres: ## Starts PostgreSQL service
	@cd postgres && docker compose up -d

mongo: ## Starts MongoDB service
	@cd mongo && ./init.sh

roach: ## Starts CockroachDB service
	@cd cockroachdb && ./init.sh

redis: ## Starts Redis service
	@cd redis && docker compose up -d

keycloak: ## Starts Keycloak service
	@cd keycloak && docker compose up -d --build

monitor: ## Starts Monitoring service
	@cd monitor && docker compose up -d

.PHONY: up down clean cleanall cert postgres mongo roach redis keycloak monitor
