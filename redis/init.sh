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
    openssl genpkey -genparam -algorithm DH -out certs/redis.dh ||  exit 1
    bash ../scripts/step_certs.sh -h redis
    chmod -Rf 777 ./certs/*
fi

ROOT_CA=$(cat ./certs/root_ca.crt)

if test -z "$ROOT_CA"; then
    docker compose down
    rm -rf ./certs;
    exit 1
fi

setup_cluster() {
    docker exec redis bash -c \
        'chown -Rf 999 /certs && chmod -Rf 660 /certs/* && \
        echo 1 > /proc/sys/vm/overcommit_memory;' && \
    docker restart -t 1 redis > /dev/null ||:
    for (( NODE_ID=1 ; NODE_ID<=$1 ; NODE_ID++ )); do
        docker exec "redis-${NODE_ID}" bash -c \
            'echo 1 > /proc/sys/vm/overcommit_memory;' && \
        docker restart -t 1 "redis-${NODE_ID}" > /dev/null ||:
    done
}

# Start docker stack
docker compose up -d || exit 1

echo "Waiting for cluster to be initialised..."

# Initializing cluster
sleep 4 && setup_cluster 5 && \
docker exec -it redis redis-cli \
    --tls --cacert /certs/root_ca.crt \
    --user admin --pass 4ENaV85jZWlxrlWnDzvB4JyJ \
    --cluster create \
        172.40.1.0:6379 \
        172.40.1.1:6381 \
        172.40.1.2:6382 \
        172.40.1.3:6383 \
        172.40.1.4:6384 \
        172.40.1.5:6385 \
    --cluster-replicas 1 && \
echo "Cluster initialised successfully"

cat <<EOF

RedisInsight connection details:

Host:       172.40.1.0
Port:       6379
Username:   admin
Password:   4ENaV85jZWlxrlWnDzvB4JyJ
Use TLS:    True
Verify TLS: True
CA Name:    Ripples CA

Root Certificate:

${ROOT_CA}

EOF
