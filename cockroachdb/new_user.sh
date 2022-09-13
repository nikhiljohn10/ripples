#!/usr/bin/env bash

USERNAME=""
PASSWORD=""
SHOW_URL=""
DETETE_USER=""
FILENAME="$0"
SQL_USER_ROLES=""
SQL_ROLE_CREATEDB=""
SQL_ROLE_VIEWACTIVITY=""
UTILS_SOURCE="$(pwd)/scripts/utidls.sh"

if !(test -f $UTILS_SOURCE); then
    UTILS_SOURCE=$(find ~ -name utils.sh -type f -print -quit)
    test -z $UTILS_SOURCE && \
        echo "Unable to file 'utils.sh'" && exit 1
fi
. $UTILS_SOURCE

show_help() {
    echo "Usage: $(basename $FILENAME) -u SQL_USER -p [PASSWORD] [-s|-d]"
    echo "  Option '-u' will create the user"
    echo "  Option '-p' will ask for user password"
    echo "  Option '-c' will add user role of CREATEDB"
    echo "  Option '-c' will add user role of CREATEDB"
    echo "  Option '-a' will show urls"
    echo "  Option '-d' will delete the user"
    echo "  Option '-s' will show urls"
    echo "  Option '-h' will show help"
}

parser_args() {
    while (($# > 0)); do
        OPTION=$1
        case $OPTION in
            -u)
                !(is_empty "$USERNAME") && error_exit "Option Error: Duplicate username option"
                if is_empty "$2"; then
                    read_user
                else
                    USERNAME="$2"
                    shift
                fi
            ;;
            -p)
                !(is_empty "$PASSWORD") && error_exit "Option Error: Duplicate password option"
                if is_empty "$2"; then
                    PASSWORD="true"
                else
                    PASSWORD="$2"
                    shift
                fi
            ;;
            -c)
                SQL_ROLE_CREATEDB="true"
            ;;
            -a)
                SQL_ROLE_VIEWACTIVITY="true"
            ;;
            -s)
                SHOW_URL="true"
            ;;
            -d)
                DETETE_USER="true"
            ;;
            -h)
                show_help
            ;;
            *)
                error_exit "Invalid option: $OPTION"
            ;;
        esac
        shift
    done
}

build_sql_command() {
    if is_true "$DETETE_USER"; then
        SQL_COMMAND="DROP USER IF EXISTS $USERNAME"
        return 0
    fi
    SQL_COMMAND="CREATE USER $USERNAME"
    if (is_true $SQL_ROLE_CREATEDB || is_true $SQL_ROLE_VIEWACTIVITY || !(is_empty "$PASSWORD")); then
        is_true $SQL_ROLE_CREATEDB && SQL_USER_ROLES="$SQL_USER_ROLES CREATEDB"
        is_true $SQL_ROLE_VIEWACTIVITY && SQL_USER_ROLES="$SQL_USER_ROLES VIEWACTIVITY"
        is_empty "$PASSWORD" || SQL_USER_ROLES="$SQL_USER_ROLES PASSWORD '$PASSWORD'"
        SQL_COMMAND="$SQL_COMMAND WITH$SQL_USER_ROLES;"
        return 0
    fi
    SQL_COMMAND="$SQL_COMMAND;"
}

# Parse commandline arguments
parser_args $@

# Username if not given
is_empty "$USERNAME" && read_user
is_true "$PASSWORD" && read_pass

# Avoid admin users
test "$USERNAME" = "admin" -o "$USERNAME" = "root" && \
    error_exit "You are not allowed to access administrative users."

# Create SQL query
build_sql_command

# Generate client certificate
if is_true "$DETETE_USER"; then
    rm -rf certs/roach/client.$USERNAME.* && \
    echo "Deleted certificate of $USERNAME"
else
    docker run --rm -it \
        -e NEW_SQL_USER=$USERNAME \
        -e HOST_UID=$(id -u $(whoami)) \
        -e HOST_GID=$(id -g $(whoami)) \
        -v $(pwd)/certs:/cockroach/temp_certs:rw \
        --entrypoint bash cockroachdb:v22.1.6-local -c \
            'cockroach cert create-client $NEW_SQL_USER \
                --certs-dir=certs/ \
                --ca-key=certs/ca.key && \
            cp -f certs/client.$NEW_SQL_USER.* temp_certs/ && \
            chown -Rf $HOST_UID:$HOST_GID temp_certs' && \
    echo "Geneated client certificate and key for $USERNAME" || exit 1 
fi

# Run SQL query
docker exec roach cockroach sql \
    --certs-dir=certs/ \
    --host=roach \
    --execute="$SQL_COMMAND" || exit 1

# Show URL
if is_true "$SHOW_URL"; then
    echo
    if !(is_empty "$PASSWORD"); then
        echo "DATABASE_URL=\"postgresql://$USERNAME:$PASSWORD@localhost:26257/exampledb?sslmode=verify-full&options=--cluster%3Droach-intrusion\""
    else
        echo "DATABASE_URL=\"postgresql://$USERNAME@localhost:26257/exampledb?sslcert=certs%2Fclient.root.crt&sslkey=certs%2Fclient.root.key&sslmode=verify-full&sslrootcert=certs%2Fca.crt&options=--cluster%3Droach-intrusion\""
    fi
    echo
fi
