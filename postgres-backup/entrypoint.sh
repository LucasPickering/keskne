#!/bin/sh

# We expect these env variables:
# - POSTGRES_HOST
# - POSTGRES_USER
# - POSTGRES_PASSWORD_FILE
# - S3_BUCKET
# - S3_ACCESS_KEY_FILE
# - S3_SECRET_KEY_FILE

# Add keys to s3 cfg file
sed -i -r "s@^access_key =.*\$@access_key = $(cat $S3_ACCESS_KEY_FILE)@" /root/.s3cfg
sed -i -r "s@^secret_key =.*\$@secret_key = $(cat $S3_SECRET_KEY_FILE)@" /root/.s3cfg

exec "$@"
