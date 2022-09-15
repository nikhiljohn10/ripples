#!/usr/bin/env bash

# Check for Certificate Authority
if !(bash ../scripts/ca_check.sh); then 
    echo "Please start ca container to continue."
    exit 1
fi

# Remove old containers if `-f` option given
if test "$1" = "-f"; then
    docker compose down 2>/dev/null
    rm -rf ./certs
fi

# Generate certificate
if !(test -d "$(pwd)/certs"); then
    bash ../scripts/step_certs.sh -rsa -h keycloak
    cat ./certs/root_ca.crt >> ./certs/server.crt
fi

# Start docker stack
docker compose up -d --build || exit 1

# Download certificate
if !(which jq >/dev/null 2>&1); then
    echo "Require `jq` for parsing."
    echo "Installing `jq`"
    sudo apt update && sudo apt install -y jq
fi
CERTIFICATE_CONTENT=$(curl -sk https://localhost:60443/realms/registry/protocol/openid-connect/certs | jq -r .keys[0].x5c[0])
cat <<EOF  >$(pwd)/certs/keycloak.crt
-----BEGIN CERTIFICATE-----
$(echo $CERTIFICATE_CONTENT|fold -w 64)
-----END CERTIFICATE-----
EOF

cat <<EOF

Admin UI:   https://localhost:60443
Username:   admin
Password:   Keycloak@123

EOF
