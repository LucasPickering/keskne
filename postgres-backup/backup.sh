#!/bin/sh

set -e

# Add more DBs here
DATABASES="rps"

cd /var/lib/postgresql
mkdir -p backups

echo "Starting DB backup at $(date)"
PGPASSWORD=$(cat $POSTGRES_PASSWORD_FILE)
for db in $DATABASES; do
    echo "Dumping $db"
    PGPASSWORD=$PGPASSWORD pg_dump $db -h $POSTGRES_HOST -U $POSTGRES_USER -w > backups/${db}.bak
done

FILE_NAME=backups-$(date -u +"%Y-%m-%dT%H:%M:%SZ").tar.gz
tar czvf "$FILE_NAME" backups/
s3cmd put "$FILE_NAME" s3://${S3_BUCKET}
