#!/usr/bin/env bash

show_help() {
   echo "Usage: $(basename $0) USERNAME PASSWORD FILENAME"
}

if test "$1" = "-h"; then
   show_help && exit 0
fi

if test -z "$1" -o -z "$2" -o -z "$3"; then
   echo "Error: Invalid format"
   echo
   show_help
   echo
   exit 1
fi

AUTH_USERNAME=$1
AUTH_PASSWORD=$2
AUTH_FILENAME=$3

if !(which htpasswd >/dev/null 2>&1); then
   sudo apt update && sudo apt install -y apache2-utils
fi
mkdir -p $(pwd)/secrets
htpasswd -Bbn $AUTH_USERNAME $AUTH_PASSWORD > $(pwd)/secrets/$AUTH_FILENAME
