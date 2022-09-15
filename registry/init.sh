#!/usr/bin/env bash

clean() {
    docker compose down 2>/dev/null
    docker volume rm registry_registry-data -f
}

generate_certificates() {
    bash ../scripts/step_certs.sh -rsa -h registry && \
    if test -f "$(pwd)/certs/keycloak.crt"; then
        CERTIFICATE_CONTENT=$(cat $(pwd)/certs/keycloak.crt)
    else
        echo "Paste OAuth provider certificate: " && \
        read CERTIFICATE_CONTENT
        echo $CERTIFICATE_CONTENT > $(pwd)/certs/keycloak.crt
    fi
        cat <<EOF >$(pwd)/certs/bundle.crt
-----BEGIN CERTIFICATE-----
$(echo $CERTIFICATE_CONTENT|fold -w 64)
-----END CERTIFICATE-----
EOF
    cat ./certs/root_ca.crt >> ./certs/bundle.crt
}

# Remove old containers and volumes if `-f` option given
test "$2" = "-f" && clean

if test "$1" = "--prod"; then
    # Generate localhost certificate
    generate_certificates

    echo "TODO: Add client certificate"

    # Start docker stack
    docker compose -f "docker-compose.prod.yml" up -d
elif test "$1" = "--oauth"; then
    # Generate localhost certificate
    generate_certificates

    # Start docker stack
    docker compose -f "docker-compose.oauth.yml" up -d
else
    # Remove old containers and volumes if `-f` option given
    test "$1" = "-f" && clean

    # Generate htpasswd file
    bash ../scripts/htpasswd.sh captain Registry@123 registry_htpasswd

    # Start docker stack
    docker compose up -d
fi
