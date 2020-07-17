#!/bin/bash

set -e
echo "Filling site template confs..."
envsubst '${ROOT_HOSTNAME}' < nginx.conf > /etc/nginx/nginx.conf
(cd sites; for f in *; do envsubst '${ROOT_HOSTNAME} ${RPS_HOSTNAME} ${GDLK_HOSTNAME}' < $f > /etc/nginx/conf.d/$f; done)

# Allow for placeholder keys in development
if [ $(expr length "$REVPROXY_AMPLIFY_API_KEY") -lt 5  ]; then
    echo "No Amplify API key specified, not starting it"
    nginx -g "daemon off;"
else
    # Amplify image's author doesn't know the difference between entrypoint and cmd
    # the "entrypoint" script starts nginx and waits for it to exit
    AMPLIFY_IMAGENAME=${ROOT_HOSTNAME} API_KEY=${REVPROXY_AMPLIFY_API_KEY} /entrypoint.sh $@
fi
