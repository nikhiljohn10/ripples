#!/usr/bin/env bash

STATUS=$(docker exec ca curl -sk https://localhost:9000/health 2>/dev/null || exit 1)

if !(test "$STATUS" = "{\"status\":\"ok\"}"); then
   exit 1
fi
