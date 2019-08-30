#!/bin/sh

export API_KEY=$(cat /run/secrets/keskne_revproxy_amplify_api_key)
/entrypoint.sh
exec "$@"
