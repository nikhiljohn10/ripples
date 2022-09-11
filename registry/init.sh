#!/usr/bin/env bash

# Remove old containers and volumes if `-f` option given
if test "$1" = "-f"; then
    docker compose down 2>/dev/null
    docker volume prune -f
fi

# Generate localhost certificate
bash ../scripts/step_certs.sh

# Generate htpasswd file
bash ../scripts/htpasswd.sh admin Registry@123 registry_htpasswd

# Start docker stack
docker compose up -d || exit 1
