#!/usr/bin/env bash

VERSION="0.22.0"
DOCKER_NETWORK="docker-networks"
CA_KEY_TYPE="EC"
CA_URL="https://ca:9000"
CA_FINGERPRINT=$(docker exec stepca step certificate fingerprint certs/root_ca.crt)

HOST_LIST="--san 127.0.0.1 --san localhost"
EXT_OPTIONS=""
parser_args() {
    while (($# > 0)); do
        OPTION=$1
        case $OPTION in
            -h)
                HOST_LIST="$HOST_LIST --san $2"
                shift
            ;;
            -rsa)
                CA_KEY_TYPE="RSA"
            ;;
            *)
                EXT_OPTIONS="$EXT_OPTIONS $OPTION"
            ;;
        esac
        shift
    done
}

parser_args $@ && \
CA_TOKEN=$(\
    docker exec stepca step ca token localhost $HOST_LIST \
        --provisioner admin \
        --password-file /home/step/secrets/password) && \
docker run --rm -it --network $DOCKER_NETWORK -u root \
    -e HOST_UID=$(id -u $(whoami)) \
    -e HOST_GID=$(id -g $(whoami)) \
    -e CA_TOKEN=$CA_TOKEN \
    -e CA_KEY_TYPE=$CA_KEY_TYPE \
    -e CA_URL=$CA_URL \
    -e CA_FINGERPRINT=$CA_FINGERPRINT \
    -v $(pwd)/certs:/root/certs \
    smallstep/step-cli:$VERSION bash -c \
'step ca bootstrap --ca-url $CA_URL --fingerprint $CA_FINGERPRINT >/dev/null 2>&1
step ca certificate --token $CA_TOKEN --kty $CA_KEY_TYPE -f localhost /root/certs/server.crt /root/certs/server.key
cp /home/step/certs/root_ca.crt /root/certs/root_ca.crt
chown -Rf $HOST_UID:$HOST_GID /root/certs'
