#!/bin/bash

set -e
cp nginx.conf /etc/nginx/nginx.conf
(cd sites; for f in *; do envsubst '${ROOT_HOSTNAME} ${RPS_HOSTNAME} ${MBTA_HOSTNAME}' < $f > /etc/nginx/conf.d/$f; done)
nginx -g "daemon off;"
