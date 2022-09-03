#!/usr/bin/env bash

# Docker
DOCKER_COMPOSE_FILE="docker-compose.roach.yml"

# Remove old containers and volumes if `-f` option given
if test "$1" = "-f"; then
    clear && \
    docker compose -f $DOCKER_COMPOSE_FILE down 2>/dev/null && \
    docker volume prune -f
fi

# Start docker stack
docker compose -f $DOCKER_COMPOSE_FILE up -d || exit 1

# Initialise Cluster
docker exec roach ./cockroach init --insecure

cat << EOF

Web UI:       http://localhost:20000
SQL URL:      postgresql://root@localhost:26257/defaultdb?sslmode=disable
SQL (JDBC):   jdbc:postgresql://localhost:26257/defaultdb?sslmode=disable&user=root

EOF
