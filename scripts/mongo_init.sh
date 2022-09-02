#!/usr/bin/env bash

# clear && \
# docker compose -f "docker-compose.mongo.yml" down && \
# docker volume prune -f

if ! test -f "secrets/mongo-replication.key"; then
    mkdir -p secrets
    (openssl rand -base64 768 > secrets/mongo-replication.key && \
    chmod 400 secrets/mongo-replication.key && \
    sudo chown 999:999 secrets/mongo-replication.key) || \
    (sudo rm -rf secrets && exit 1)
fi

docker compose -f "docker-compose.mongo.yml" up -d && \
sleep 2 || exit 1

result=$(docker run --rm --network "docker-networks" \
    mongo:5 mongosh --quiet \
    --host mongo:27017 \
    --username admin \
    --password MongoAdmin12 \
    --authenticationDatabase admin admin \
    --eval "
        db.auth('admin', 'MongoAdmin12');
        rs.initiate(
            {_id: \"mReplSet\", version: 1,
                members: [
                    { _id: 0, host : \"mongo:27017\", priority: 10 },
                    { _id: 1, host : \"mongo-1:27017\", priority: 1 },
                    { _id: 2, host : \"mongo-2:27017\", priority: 1 }
                ]
            }
        );")

test "$result" = "{ ok: 1 }" && (\
        echo -n "Waiting for cluster to be initialised..." && \
        sleep 10 && echo -e "\033[2K\rCluster initialised successfully") || \
    echo -n "$result"

echo -n "Cluster status: "
docker run --rm --network "docker-networks" \
    mongo:5 mongosh --quiet \
    --host mongo:27017 \
    --username admin \
    --password MongoAdmin12 \
    --authenticationDatabase admin admin \
    --eval "rs.status()"