#!/usr/bin/env bash

# Remove old containers and volumes if `-f` option given
if test "$1" = "-f"; then
    docker compose down 2>/dev/null && \
    docker volume prune -f
fi

# Start docker stack
docker compose up -d || exit 1
