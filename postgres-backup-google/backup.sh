#!/bin/sh

set -e

cd /var/lib/postgresql
mkdir -p backups


password=$(cat $POSTGRES_PASSWORD_FILE)
bucket=gs://$(cat $CLOUD_STORAGE_BUCKET_FILE)

echo "Starting DB backup at $(date)"
for db in $DATABASES; do
    echo "Dumping $db"
    PGPASSWORD=$password pg_dump $db -h $POSTGRES_HOST -U $POSTGRES_USER -w > backups/${db}.sql
done

# Check if the bucket has object versioning enabled. If so, we want to use the
# same file name on every backup. If not, we want to include the date for our
# own versioning system.
if gsutil versioning get $bucket | grep -iq enabled; then
    # versioning is enabled on the bucket
    file_name=backups.tar.gz
else
    file_name=backups-$(date -u +"%Y-%m-%dT%H:%M:%SZ").tar.gz
fi
echo "Packaging and uploading $file_name"
tar czvf "$file_name" backups/
gsutil cp "$file_name" $bucket
