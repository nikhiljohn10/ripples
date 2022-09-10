#!/usr/bin/env bash

VERSION="0.22.0"
DOCKER_NETWORK="docker-networks"
CA_URL="https://ca:9000"
CA_FINGERPRINT=$(docker exec ca step certificate fingerprint certs/root_ca.crt)
CA_TOKEN=$(docker exec ca step ca token localhost --provisioner admin --password-file /home/step/secrets/password)

docker run --rm -it --network $DOCKER_NETWORK -u root \
    -e HOST_UID=$(id -u $(whoami)) \
    -e HOST_GID=$(id -g $(whoami)) \
    -e CA_TOKEN=$CA_TOKEN \
    -e CA_URL=$CA_URL \
    -e CA_FINGERPRINT=$CA_FINGERPRINT \
    -v $(pwd)/certs:/root/certs \
    smallstep/step-cli:$VERSION bash -c \
'step ca bootstrap --ca-url $CA_URL --fingerprint $CA_FINGERPRINT
step ca certificate --token $CA_TOKEN -f localhost /root/certs/server.crt /root/certs/server.key
cp /home/step/certs/root_ca.crt /root/certs/root_ca.crt
chown -Rf $HOST_UID:$HOST_GID /root/certs'
