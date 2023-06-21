#!/bin/bash

if [ -n "${PASSWORD}" ] || [ -n "${HASHED_PASSWORD}" ]; then
    AUTH="password"
else
    AUTH="none"
    echo "starting with no password"
fi

if [ -z ${PROXY_DOMAIN+x} ]; then
    PROXY_DOMAIN_ARG=""
else
    PROXY_DOMAIN_ARG="--proxy-domain=${PROXY_DOMAIN}"
fi

exec \
  /app/code-server/bin/code-server \
    --bind-addr 0.0.0.0:8443 \
    --user-data-dir /config/data \
    --extensions-dir /config/extensions \
    --disable-telemetry \
    --auth "${AUTH}" \
    "${PROXY_DOMAIN_ARG}" \
    "${DEFAULT_WORKSPACE:-/config/workspace}"
