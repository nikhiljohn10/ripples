#!/usr/bin/env bash

docker volume prune --force
docker network prune --force

if test "$1" = "+i"; then
   docker image prune -a --force
fi
