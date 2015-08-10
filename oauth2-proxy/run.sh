#!/usr/bin/env bash
set -e

if [ -z $CLIENT_ID ]; then
  echo "You must set the CLIENT_ID environment variable!"
  exit 1
fi

if [ -z $CLIENT_SECRET ]; then
  echo "You must set the CLIENT_SECRET environment variable!"
  exit 1
fi

if [ -z $COOKIE_SECRET ]; then
  echo "You must set the COOKIE_SECRET environment variable!"
  exit 1
fi

export UPSTREAM=${UPSTREAM:-}
export REDIRECT_URL=${REDIRECT_URL:-}
export EMAIL_DOMAIN=${EMAIL_DOMAIN:-gallop.io}
export COOKIE_DOMAIN=${COOKIE_DOMAIN:-.gallop.io}

exec /usr/local/bin/oauth2_proxy \
  -http-address=0.0.0.0:4180 \
  -https-address=0.0.0.0:443 \
  -upstream=${UPSTREAM} \
  -redirect-url=${REDIRECT_URL} \
  -cookie-domain=${COOKIE_DOMAIN} \
  -cookie-secret=${COOKIE_SECRET} \
  -client-id=${CLIENT_ID} \
  -client-secret ${CLIENT_SECRET} \
  -email-domain=${EMAIL_DOMAIN} \
  $@
