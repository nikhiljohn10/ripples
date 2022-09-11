#!/usr/bin/env bash

# Check for Certificate Authority
if !(bash ../scripts/ca_check.sh); then 
    echo "Please start ca container to continue."
    exit 1
fi

# Remove old containers and volumes if `-f` option given
if test "$1" = "-f"; then
    docker compose down 2>/dev/null
    docker volume prune -f
fi

# Generate certificate
if !(test -d "$(pwd)/certs"); then
    mkdir -p certs
    bash ../scripts/step_certs.sh RSA
    cat ./certs/root_ca.crt >> ./certs/server.crt
fi

# Start docker stack
docker compose up -d --build || exit 1

cat <<EOF

Admin UI:   https://localhost:50443
Username:   admin
Password:   Keycloak@123

EOF
