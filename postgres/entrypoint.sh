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

# Add keys to s3 cfg file
sed -i -r "s@^access_key =.*\$@access_key = ${S3_ACCESS_KEY}@" /root/.s3cfg
sed -i -r "s@^secret_key =.*\$@secret_key = ${S3_SECRET_KEY}@" /root/.s3cfg

exec "$@"
