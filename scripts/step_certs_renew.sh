#!/usr/bin/env bash

CERTS_DIR=$(pwd)/certs

if !(test -f "$CERTS_DIR/server.crt" -a -f "$CERTS_DIR/server.key"); then
    exit 0
fi

VERSION="0.22.0"
DOCKER_NETWORK="docker-networks"
CA_URL="https://ca:9000"
CA_FINGERPRINT=$(docker exec ca step certificate fingerprint certs/root_ca.crt)

docker run --rm -it --network $DOCKER_NETWORK -u root \
    -e HOST_UID=$(id -u $(whoami)) \
    -e HOST_GID=$(id -g $(whoami)) \
    -e CA_URL=$CA_URL \
    -e CA_FINGERPRINT=$CA_FINGERPRINT \
    -v $CERTS_DIR:/root/certs \
    smallstep/step-cli:$VERSION bash -c \
'step ca bootstrap --ca-url $CA_URL --fingerprint $CA_FINGERPRINT
step ca renew --force /root/certs/server.crt /root/certs/server.key
cp /home/step/certs/root_ca.crt /root/certs/root_ca.crt
chown -Rf $HOST_UID:$HOST_GID /root/certs'
