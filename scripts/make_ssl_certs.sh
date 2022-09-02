#!/usr/bin/env bash

CERT_PATH="certs"

mkdir -p $CERT_PATH

openssl req -x509 -out $CERT_PATH/cert.pem -keyout $CERT_PATH/key.pem \
  -newkey rsa:2048 -nodes -sha256 \
  -subj '/CN=localhost' -extensions EXT -config <( \
   printf "[dn]\nCN=localhost\n[req]\ndistinguished_name = dn\n[EXT]\nsubjectAltName=DNS:localhost\nkeyUsage=digitalSignature\nextendedKeyUsage=serverAuth")
