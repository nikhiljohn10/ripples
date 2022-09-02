#!/usr/bin/env bash

DOCKER_COMPOSE_FILE="docker-compose.roach.yml"

if test "$1" = "-f"; then
    clear && \
    docker compose -f $DOCKER_COMPOSE_FILE down 2>/dev/null && \
    docker volume prune -f
fi

docker compose -f $DOCKER_COMPOSE_FILE up -d || exit 1

docker exec roach ./cockroach init --insecure
cat << EOF

Web UI:       http://localhost:20000
SQL URL:      postgresql://root@localhost:26257/defaultdb?sslmode=disable
SQL (JDBC):   jdbc:postgresql://localhost:26257/defaultdb?sslmode=disable&user=root

EOF
