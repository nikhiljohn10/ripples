#!/usr/bin/env bash

SECRETS_DIR="secrets"
DOCKER_COMPOSE_FILE="docker-compose.mongo.yml"
REPLICATION_KEY_FILE="$SECRETS_DIR/mongo-replication.key"

DOCKER_NETWORK="docker-networks"

MDB_USERNAME="admin"
MDB_PASSWORD="MongoAdmin12"
MDB_AUTH_DB="admin"

CLUSTER_NAME="mReplSet"
PRIMARY_CLUSTER="mongo:27017"
SECONDARY_CLUSTER_1="mongo-1:27017"
SECONDARY_CLUSTER_2="mongo-2:27017"

if test "$1" = "-f"; then
    clear && \
    docker compose -f "docker-compose.mongo.yml" down && \
    docker volume prune -f
fi

if ! test -f "$REPLICATION_KEY_FILE"; then
    mkdir -p $SECRETS_DIR
    (openssl rand -base64 768 > $REPLICATION_KEY_FILE && \
    chmod 400 $REPLICATION_KEY_FILE && \
    sudo chown 999:999 $REPLICATION_KEY_FILE) || \
    (sudo rm -rf $SECRETS_DIR && exit 1)
fi

docker compose -f $DOCKER_COMPOSE_FILE up -d && \
sleep 2 || exit 1

result=$(docker run --rm --network $DOCKER_NETWORK \
    mongo:5 mongosh --quiet \
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

echo -n "Cluster status: "
docker run --rm --network $DOCKER_NETWORK \
    mongo:5 mongosh --quiet \
    --host $PRIMARY_CLUSTER \
    --username $MDB_USERNAME \
    --password $MDB_PASSWORD \
    --authenticationDatabase $MDB_AUTH_DB $MDB_AUTH_DB \
    --eval "rs.status()"
