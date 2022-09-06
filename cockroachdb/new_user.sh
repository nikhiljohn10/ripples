#!/usr/bin/env bash

if (test -z "$1"); then
    echo "Error: Missing argument."
    echo "    Usage: $(basename $0) [SQL_USER] [-d|-p [PASSWORD]]"
    echo "The command will create the user"
    echo "Option '-d' will delete the user"
    echo "Option '-p' will ask for user password"
    exit 1
fi

USER_NAME=$1

if (test "$USER_NAME" = "admin" -o "$USER_NAME" = "root"); then
    echo "You are not allowed to access administrative users."
    exit 1
fi

SQL_COMMAND="CREATE USER $USER_NAME WITH CREATEDB VIEWACTIVITY"

if test "$2" = "-d"; then
    SQL_COMMAND="DROP USER IF EXISTS $USER_NAME"
elif test "$2" = "-p"; then
    if test -z "$3"; then
        echo -n "Password: "
        read -s USER_PASSWORD
        echo -ne "\033[2K\r"
    else
        USER_PASSWORD=$3
    fi
    SQL_COMMAND="$SQL_COMMAND PASSWORD '$USER_PASSWORD'"
else
    docker run --rm -it \
        -e NEW_SQL_USER=$USER_NAME \
        -e HOST_UID=$(id -u $(whoami)) \
        -e HOST_GID=$(id -g $(whoami)) \
        -v $(pwd)/certs:/cockroach/temp_certs:rw \
        --entrypoint bash cockroachdb:v22.1.6-local -c \
            'cockroach cert create-client $NEW_SQL_USER \
                --certs-dir=certs/ \
                --ca-key=certs/ca.key && \
            cp -f certs/client.$NEW_SQL_USER.* temp_certs/ && \
            chown -Rf $HOST_UID:$HOST_GID temp_certs' || exit 1
fi

docker exec roach cockroach sql \
    --certs-dir=certs/ \
    --host=roach \
    --execute="$SQL_COMMAND;" || exit 1

if !(test -z "$USER_PASSWORD"); then
    echo "DATABASE_URL=\"postgresql://$USER_NAME:$USER_PASSWORD@localhost:26257/exampledb?sslmode=verify-full&options=--cluster%3Droach-intrusion\""
elif (test "$2" = "-d"); then
    rm -rf certs/roach/client.$USER_NAME.*
else
    echo "DATABASE_URL=\"postgresql://$USER_NAME@localhost:26257/exampledb?sslcert=certs%2Fclient.root.crt&sslkey=certs%2Fclient.root.key&sslmode=verify-full&sslrootcert=certs%2Fca.crt&options=--cluster%3Droach-intrusion\""
fi
