#!/bin/sh

set -e

cd /var/lib/postgresql
mkdir -p backups


password=$(cat $POSTGRES_PASSWORD_FILE)
bucket=$(cat $CLOUD_STORAGE_BUCKET_FILE)

echo "Starting DB backup at $(date)"
for db in $DATABASES; do
    echo "Dumping $db"
    PGPASSWORD=$password pg_dump $db -h $POSTGRES_HOST -U $POSTGRES_USER -w > backups/${db}.sql
done

FILE_NAME=backups-$(date -u +"%Y-%m-%dT%H:%M:%SZ").tar.gz
tar czvf "$FILE_NAME" backups/
gsutil cp "$FILE_NAME" gs://$bucket
