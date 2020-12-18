#!/bin/bash

# Env vars we expect as input:
# - ROOT_HOSTNAME
# - RPS_HOSTNAME
# - LAULUD_HOSTNAME
# - AMPLIFY_API_KEY_FILE

set -e
echo "Filling site template confs..."
envsubst '${ROOT_HOSTNAME}' < nginx.conf > /etc/nginx/nginx.conf
(cd sites; for f in *; do envsubst '${ROOT_HOSTNAME} ${RPS_HOSTNAME} ${LAULUD_HOSTNAME}' < $f > /etc/nginx/conf.d/$f; done)

# Allow for placeholder keys in development
amplify_key=$(cat $AMPLIFY_API_KEY_FILE)
if [ $(expr length "$amplify_key") -lt 5  ]; then
    echo "No Amplify API key specified, not starting it"
    nginx -g "daemon off;"
else
    # Amplify image's author doesn't know the difference between entrypoint and cmd
    # the "entrypoint" script starts nginx and waits for it to exit
    AMPLIFY_IMAGENAME=${ROOT_HOSTNAME} API_KEY=${amplify_key} /entrypoint.sh $@
fi
