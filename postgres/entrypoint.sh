#!/bin/sh

# Read each secret file into an env var
for f in ${SECRETS_DIR-"/run/secrets/"}*; do
    if [ -e "$f" ]; then
        # Strip any prefixes before before "keskne_", then convert to upper case
        var_name=$(echo $f | sed -E 's/^.*?keskne_(.*)$/\1/' | tr '[:lower:]' '[:upper:]')
        echo "Reading \"$f\" into \"$var_name\""
        export $var_name=$(cat $f) # Load the secret value
    fi
done

exec /usr/local/bin/docker-entrypoint.sh "$@"
