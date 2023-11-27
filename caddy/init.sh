#!/usr/bin/env bash

# Check for Certificate Authority
if !(bash ../scripts/ca_check.sh); then
    echo "Please start ca container to continue."
    exit 1
fi

# Remove old containers if `-f` option given
if test "$1" = "-f"; then
    docker compose down 2>/dev/null
    # docker volume rm caddy_data -f
    docker volume rm caddy_config -f
fi

# Generate certificate
if !(test -d "$(pwd)/certs"); then
    mkdir ./certs
    (docker exec stepca cat /home/step/certs/root_ca.crt) > ./certs/root_ca.crt
fi

# Start docker stack
docker compose up -d --build || exit 1
