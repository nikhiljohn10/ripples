#!/usr/bin/env bash

VERSION="0.22.0"
DOCKER_NETWORK="docker-networks"
CA_KEY_TYPE="EC"
CA_URL="https://ca:9000"
CA_FINGERPRINT=$(docker exec stepca step certificate fingerprint certs/root_ca.crt)
CA_TOKEN=$(docker exec stepca step ca token localhost --provisioner admin --password-file /home/step/secrets/password)

test "$1" == "RSA" && CA_KEY_TYPE="$1"

docker run --rm -it --network $DOCKER_NETWORK -u root \
    -e HOST_UID=$(id -u $(whoami)) \
    -e HOST_GID=$(id -g $(whoami)) \
    -e CA_TOKEN=$CA_TOKEN \
    -e CA_KEY_TYPE=$CA_KEY_TYPE \
    -e CA_URL=$CA_URL \
    -e CA_FINGERPRINT=$CA_FINGERPRINT \
    -v $(pwd)/certs:/root/certs \
    smallstep/step-cli:$VERSION bash -c \
'step ca bootstrap --ca-url $CA_URL --fingerprint $CA_FINGERPRINT
step ca certificate --token $CA_TOKEN --kty $CA_KEY_TYPE -f localhost /root/certs/server.crt /root/certs/server.key
cp /home/step/certs/root_ca.crt /root/certs/root_ca.crt
chown -Rf $HOST_UID:$HOST_GID /root/certs'
