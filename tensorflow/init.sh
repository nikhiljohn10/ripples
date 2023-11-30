#!/usr/bin/env bash

# Remove old containers and volumes if `-f` option given
if test "$1" = "-f"; then
    docker compose down 2>/dev/null
    docker volume rm jupyter-data keras-data -f
fi

# Start docker stack
cd ca && go run .
docker compose up -d || exit 1

cat <<EOF

Tensorflow:

    URL:            http://localhost
    Jupyter Token:  dockertoken
    GPU:            Enabled

EOF
