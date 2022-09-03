#!/usr/bin/env bash

# Docker
DOCKER_COMPOSE_FILE="docker-compose.roach.yml"

# Remove old containers and volumes if `-f` option given
if test "$1" = "-f"; then
    docker compose -f $DOCKER_COMPOSE_FILE down 2>/dev/null && \
    docker volume prune -f
fi

# Start docker stack
docker build ./Dockerfiles/roach/ -t cockroachdb:v22.1.6-local && \
docker compose -f $DOCKER_COMPOSE_FILE up -d || exit 1

# Generate and copy ca and client certificates
docker run --rm -it \
    -e HOST_UID=$(id -u $(whoami)) \
    -e HOST_GID=$(id -g $(whoami)) \
    -v $(pwd)/certs/roach:/cockroach/temp_certs:rw \
    --entrypoint bash cockroachdb:v22.1.6-local -c \
    'cp certs/ca.crt certs/client.root.* temp_certs/ && \
    chown -Rf $HOST_UID:$HOST_GID temp_certs' || exit 1

# Initialise Cluster
docker compose -f $DOCKER_COMPOSE_FILE exec roach cockroach \
    init \
    --cluster-name=roach-intrusion \
    --certs-dir=certs/ || exit 1

# Create admin user
docker compose -f $DOCKER_COMPOSE_FILE exec roach cockroach \
    sql \
    --certs-dir=certs/ \
    --host=roach \
    --execute="CREATE USER roach WITH PASSWORD 'Cockroach@12';" > /dev/null 2>&1 &&
echo "Admin user 'roach' is created successfully" || exit 1

cat << EOF

Web UI:       http://localhost:20000
SQL URL:      postgresql://root@roach:26257/defaultdb?sslcert=certs%2Fclient.root.crt&sslkey=certs%2Fclient.root.key&sslmode=verify-full&sslrootcert=certs%2Fca.crt
SQL (JDBC):   jdbc:postgresql://roach:26257/defaultdb?sslcert=certs%2Fclient.root.crt&sslkey=certs%2Fclient.root.key&sslmode=verify-full&sslrootcert=certs%2Fca.crt&user=root
CA cert:      certs/roach/ca.crt
Client cert:  certs/roach/client.root.crt
Client key:   certs/roach/client.root.key

EOF
