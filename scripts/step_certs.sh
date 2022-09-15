#!/usr/bin/env bash

PASSWORD=""
PASSWORD_OPTION=""
CA_KEY_TYPE="EC"
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
            -p)
                PASSWORD=$(openssl rand -base64 32)
            ;;
            *)
                echo "Invalid option found: $OPTION"
                echo "$OPTION is ignored"
            ;;
        esac
        shift
    done
}

execute() {
    docker exec stepca $@
}

copy_to_host() {
    (docker exec stepca cat $1) > $2
}

parser_args $@

if test -z "$PASSWORD"; then
    PASSWORD_OPTION="--no-password --insecure"
else
    PASSWORD_OPTION="--password-file <(echo \"$PASSWORD\")"
fi

COMMAND="mkdir -p /home/step/localhost && \
step certificate create localhost \
    /home/step/localhost/server.crt \
    /home/step/localhost/server.key \
        --force \
        --profile leaf \
        --kty ${CA_KEY_TYPE} \
        --not-after=2160h \
        --ca /home/step/certs/intermediate_ca.crt \
        --ca-key /home/step/secrets/intermediate_ca_key \
        --ca-password-file /home/step/secrets/password \
        ${PASSWORD_OPTION} ${HOST_LIST} --bundle"
execute mkdir -p /home/step/localhost
docker exec stepca bash -c "$(echo $COMMAND)" >/dev/null 2>&1
mkdir -p ./certs
copy_to_host /home/step/certs/root_ca.crt ./certs/root_ca.crt
copy_to_host /home/step/localhost/server.crt ./certs/server.crt
copy_to_host /home/step/localhost/server.key ./certs/server.key
test -z "$PASSWORD" || (echo "$PASSWORD" > ./certs/pass)
execute rm -rf /home/step/localhost
