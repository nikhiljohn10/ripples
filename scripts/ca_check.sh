#!/usr/bin/env bash

STATUS=$(docker exec stepca curl -sk https://ca:9000/health 2>/dev/null || exit 1)

if !(test "$STATUS" = "{\"status\":\"ok\"}"); then
   exit 1
fi
