#!/bin/bash

PREFIX=keskne_ source /app/load_secrets.sh
# Allow for placeholder keys in development
if [ $(expr length "$REVPROXY_AMPLIFY_API_KEY") -lt 5  ]; then
    echo "No Amplify API key specified, not starting it"
    exec $@
else
    AMPLIFY_IMAGENAME=${ROOT_HOSTNAME} API_KEY=${REVPROXY_AMPLIFY_API_KEY} /entrypoint.sh $@
fi
