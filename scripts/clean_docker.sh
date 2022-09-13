#!/usr/bin/env bash

docker volume prune --force
docker network prune --force
test "$1" = "-i" -o "$1" = "--prune-images" && docker image prune -a --force
