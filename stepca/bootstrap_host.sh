#!/usr/bin/env bash

VERSION="0.22.0"
CA_URL="https://localhost:19000"
CA_FINGERPRINT=$(docker exec stepca step certificate fingerprint certs/root_ca.crt)

bash ./stepca/install.sh
rm -Rf $(step path)
step ca bootstrap --ca-url $CA_URL --fingerprint $CA_FINGERPRINT
step certificate install --all $(step path)/certs/root_ca.crt
cp -f $(step path)/certs/root_ca.crt ~/Documents/ca.crt
