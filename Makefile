up: postgres mongo roach redis keyclock monitor

down:
	@-find . -type f -name "docker-compose.*.yml" -exec docker compose -f "$$(basename {})" down \;

clean:
	@./scripts/clean_docker.sh

cleanall:
	@./scripts/clean_docker.sh +i

cert:
	@./scripts/localhost_cert.sh

postgres:
	@docker compose -f "docker-compose.postgres.yml" up -d

mongo:
	@./scripts/mongo_init.sh

roach:
	@./scripts/roach_init.sh

redis:
	@docker compose -f "docker-compose.postgres.yml" up -d

keyclock:
	@docker compose -f "docker-compose.keyclock.yml" up -d --build

monitor:
	@docker compose -f "docker-compose.monitor.yml" up -d

PHONY: up down clean cleanall cert postgres mongo roach redis keyclock monitor