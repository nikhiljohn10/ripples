#!/usr/bin/env bash

# Check for Certificate Authority
if !(bash ../scripts/ca_check.sh); then 
    echo "Please start ca container to continue."
    exit 1
fi

# Remove old containers and volumes if `-f` option given
if test "$1" = "-f"; then
    docker compose down 2>/dev/null
    docker volume rm portainer_data -f
    rm -rf ./certs
fi

# Generate certificate
if !(test -d "$(pwd)/certs"); then
    bash ../scripts/step_certs.sh -h portainer
    cat ./certs/root_ca.crt >> ./certs/server.crt
    mkdir -p ./secrets
    echo -n 'Portainer@123' > ./secrets/password
fi

# Start docker stack
docker compose up -d

cat <<EOF

URL:        https://localhost:39443
Username:   admin
Password:   Portainer@123

EOF
