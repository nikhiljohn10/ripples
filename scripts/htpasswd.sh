#!/usr/bin/env bash

if test "$1" = "-h"; then
   echo "Usage: $(basename $0) USERNAME PASSWORD FILENAME"
   exit 0
fi

if test -z "$1" -o -z "$2" -o -z "$3"; then
   echo "Error: Invalid format"
   echo
   echo "Usage: $(basename $0) USERNAME PASSWORD FILENAME"
   echo
   exit 1
fi

AUTH_USERNAME=$1
AUTH_PASSWORD=$2
AUTH_FILENAME=$3

docker run --rm --entrypoint htpasswd httpd:2 -Bbn \
   $AUTH_USERNAME $AUTH_PASSWORD > $(pwd)/$AUTH_FILENAME
