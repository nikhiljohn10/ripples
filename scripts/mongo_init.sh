#!/usr/bin/env bash

# Docker
DOCKER_NETWORK="docker-networks"
DOCKER_COMPOSE_FILE="docker-compose.mongo.yml"

# Mongo
MDB_VERSION="5.0.11"
SECRETS_DIR="secrets"
REPLICATION_KEY_FILE="$SECRETS_DIR/mongo-replication.key"

# Database
MDB_USERNAME="admin"
MDB_PASSWORD="MongoAdmin12"
MDB_AUTH_DB="admin"

# Cluster
CLUSTER_NAME="mReplSet"
PRIMARY_CLUSTER="mongo:27017"
SECONDARY_CLUSTER_1="mongo-1:27017"
SECONDARY_CLUSTER_2="mongo-2:27017"

# Remove old containers and volumes if `-f` option given
if test "$1" = "-f"; then
    docker compose -f $DOCKER_COMPOSE_FILE down && \
    docker volume prune -f
fi

# Generate replication key for cluster authentication
if ! test -f "$REPLICATION_KEY_FILE"; then
    mkdir -p $SECRETS_DIR
    (openssl rand -base64 768 > $REPLICATION_KEY_FILE && \
    chmod 400 $REPLICATION_KEY_FILE && \
    sudo chown 999:999 $REPLICATION_KEY_FILE) || \
    (sudo rm -rf $SECRETS_DIR && exit 1)
fi

# Start docker stack
docker compose -f $DOCKER_COMPOSE_FILE up -d && \
sleep 2 || exit 1

# Initialise Cluster
result=$(docker run --rm --network $DOCKER_NETWORK \
    mongo:$MDB_VERSION mongosh --quiet \
    --host $PRIMARY_CLUSTER \
    --username $MDB_USERNAME \
    --password $MDB_PASSWORD \
    --authenticationDatabase $MDB_AUTH_DB $MDB_AUTH_DB \
    --eval "
        db.auth('$MDB_USERNAME', '$MDB_PASSWORD');
        rs.initiate(
            {_id: \"$CLUSTER_NAME\", version: 1,
                members: [
                    { _id: 0, host : \"$PRIMARY_CLUSTER\", priority: 10 },
                    { _id: 1, host : \"$SECONDARY_CLUSTER_1\", priority: 1 },
                    { _id: 2, host : \"$SECONDARY_CLUSTER_2\", priority: 1 }
                ]
            }
        );")

test "$result" = "{ ok: 1 }" && (\
        echo -n "Waiting for cluster to be initialised..." && \
        sleep 10 && echo -e "\033[2K\rCluster initialised successfully") || \
    echo -n "$result"

# Display cluster status
echo -n "Cluster status: "
docker run --rm --network $DOCKER_NETWORK \
    mongo:$MDB_VERSION mongosh --quiet \
    --host $PRIMARY_CLUSTER \
    --username $MDB_USERNAME \
    --password $MDB_PASSWORD \
    --authenticationDatabase $MDB_AUTH_DB $MDB_AUTH_DB \
    --eval "rs.status()"
