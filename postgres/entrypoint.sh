#!/bin/sh


# Add keys to s3 cfg file
sed -i -r "s@^access_key = .*\$@access_key = $(cat /run/secrets/keskne_s3_access_key)@" /root/.s3cfg
sed -i -r "s@^secret_key = .*\$@secret_key = $(cat /run/secrets/keskne_s3_secret_key)@" /root/.s3cfg

/docker-entrypoint.sh $@
