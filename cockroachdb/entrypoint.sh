#!/usr/bin/env bash

if !(test -f "/cockroach/certs/node.crt" -a -f "/cockroach/certs/node.key"); then
    cockroach cert create-node \
        $NODE_HOSTNAME \
        localhost \
        127.0.0.1 \
        --certs-dir=certs/ \
        --ca-key=certs/ca.key &&
    cockroach cert create-client root \
        --certs-dir=certs/ \
        --ca-key=certs/ca.key
fi
/cockroach/cockroach.sh $@
