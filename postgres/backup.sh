#!/bin/sh

set -e

cd /var/lib/postgresql
mkdir -p backups

echo $(date)
pg_dump rps > backups/rps.bak
pg_dump gdlk > backups/gdlk.bak
# Add more DBs here

FILE_NAME=backups-$(date -u +"%Y-%m-%dT%H:%M:%SZ").tar.gz
tar czvf "$FILE_NAME" backups/
s3cmd put "$FILE_NAME" s3://${S3_BUCKET}
