#!/usr/bin/env bash

docker volume prune --force
docker network prune --force

# Remove all unused image if `+i` option given
if test "$1" = "+i"; then
   docker image prune -a --force
fi
