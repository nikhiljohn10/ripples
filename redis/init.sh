#!/usr/bin/env bash

error_rootca_missing() {
    rm -rf ./certs;
    exit 1
}

error_ca_run() {
    echo "Please start ca container to continue."
    exit 1
}

clean() {
    if test "$1" = "cluster"; then
        docker compose -f "docker-compose.cluster.yml" down 2>/dev/null
    else
        docker compose down 2>/dev/null
    fi
    docker volume prune -f
}

generate_certificate() {
    mkdir -p certs
    openssl genpkey -genparam -algorithm DH -out certs/redis.dh ||  exit 1
    bash ../scripts/step_certs.sh -h redis
    chmod -Rf 777 ./certs/*
}

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

# Check for Certificate Authority
bash ../scripts/ca_check.sh || error_ca_run

# Generate certificate
test -d "$(pwd)/certs" || generate_certificate

ROOT_CA=$(cat ./certs/root_ca.crt)

test -z "$ROOT_CA" && error_rootca_missing

if test "$1" = "--cluster"; then
    # Remove old containers and volumes if `-f` option given
    test "$2" = "-f" && clean "cluster"

    # Start docker stack
    docker compose -f "docker-compose.cluster.yml" up -d

    # Initializing cluster
    echo "Waiting for cluster to be initialised..."
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
else
    # Remove old containers and volumes if `-f` option given
    test "$1" = "-f" && clean

    # Start docker stack
    docker compose up -d

    cat <<EOF

RedisInsight connection details:

Host:       localhost
Port:       6379
Username:   admin
Password:   4ENaV85jZWlxrlWnDzvB4JyJ
Use TLS:    True
Verify TLS: True
CA Name:    Ripples CA

Root Certificate:

${ROOT_CA}

EOF
fi 
