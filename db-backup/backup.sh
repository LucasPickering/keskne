#!/bin/sh

set -e

backup_dir=/app/backups
now=$(date -Iseconds)
mkdir -p $backup_dir

back_up_mongo () {
    # We'll need this outside the function
    backup_file=${backup_dir}/${db}.sql # TODO fix this

    local db=${DATABASE_NAME}
    local host=${DATABASE_HOST}
    local port=${DATABASE_PORT:-27017}

    echo "Dumping $db from $host:$port (mongo) at $now to $backup_dir"
    # TODO pass username/password
    mongodump --host=$host:$port --db=$db --out=$backup_dir
}

back_up_postgres () {
    local db=${DATABASE_NAME}
    local host=${DATABASE_HOST}
    local port=${DATABASE_PORT:-5432}
    local username=${DATABASE_USER}
    local password=$(cat $DATABASE_PASSWORD_FILE)

    # We'll need this outside the function
    backup_file=${backup_dir}/${db}.sql

    echo "Dumping $db from $host:$port (postgres) at $now to $backup_file"
    PGPASSWORD=$password pg_dump $db --host $host --port $port \
        --username $username --no-password \
        --file $backup_file --data-only
}

upload_backup () {
    local bucket=gs://$CLOUD_STORAGE_BUCKET
    local bucket_path=$bucket/$CLOUD_STORAGE_PREFIX

    gcloud auth activate-service-account --key-file=$CLOUD_STORAGE_KEY_FILE

    # Print a warning if the bucket doesn't have versioning enabled
    if gsutil versioning get $bucket | grep -iq disabled; then
        echo "WARNING: $bucket does not have object versioning enabled. \
            Previous backup will be overwritten"
    fi

    echo "Uploading $backup_file to $bucket_path"
    gsutil cp "$backup_file" "$bucket_path"
    rm "$backup_file"
}

case $DATABASE_TYPE in
    "mongo")
        back_up_mongo
        ;;
    "postgres")
        back_up_postgres
        ;;
    *)
        echo "Unknown database type: $DATABASE_TYPE; Supported values are: mongo, postgres"
        exit 1
        ;;
esac
upload_backup
