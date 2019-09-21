#!/bin/sh

cd /var/lib/postgresql
mkdir -p backups

pg_dump rps > backups/rps.bak
# Add more DBs here

tar czvf backups.tar.gz backups/
s3cmd put backups.tar.gz s3://${S3_BUCKET}
