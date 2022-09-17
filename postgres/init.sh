#!/usr/bin/env bash

# Check for Certificate Authority
if !(bash ../scripts/ca_check.sh); then 
    echo "Please start ca container to continue."
    exit 1
fi

# Remove old containers and volumes if `-f` option given
if test "$1" = "-f"; then
    docker compose down 2>/dev/null
    docker volume rm postgres_data -f
    docker volume rm postgres_admin_data -f
    rm -rf ./certs
fi

# Generate certificate
if !(test -d "$(pwd)/certs"); then
    bash ../scripts/step_certs.sh -rsa -h postgres
    cat ./certs/root_ca.crt >> ./certs/server.crt
    cp ./certs/{,pga-}server.crt
    cp ./certs/{,pga-}server.key
    chmod -Rf 600 ./certs/*
    sudo chown -Rf 999:999 ./certs/*
    sudo chown -Rf 5050:root ./certs/pga-*
fi

# Start docker stack
docker compose up -d || exit 1

cat <<EOF

Admin UI:

URL:        https://localhost:50443
Email:      admin@pgadmin.org
Password:   PGAdmin@1234

Databse connection:

Hostname:   postgres
Port:       5432
Username:   admin
Password:   Postgres1234

EOF
