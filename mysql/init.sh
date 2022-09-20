#!/usr/bin/env bash

# Remove old containers and volumes if `-f` option given
if test "$1" = "-f"; then
    docker compose down 2>/dev/null
    docker volume rm mysql_data -f
fi

# Start docker stack
docker compose up -d || exit 1

cat <<EOF

Admin UI:

URL:        https://localhost:50443

Databse connection:

Hostname:   mysql
Port:       3306
Username:   mysql
Password:   Mysql12345

EOF
