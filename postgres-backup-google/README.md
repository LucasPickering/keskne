# postgres-backup

This is an image to periodically back up a Postgres instance and upload the backup to a Google Cloud Storage bucket.

## Env Variables

Backup can be configured through a few env variables:

| Variable                    | Purpose                                            | Required? | Default             |
| --------------------------- | -------------------------------------------------- | --------- | ------------------- |
| `DATABASES`                 | Space-separated list of databases to back up       | Y         |                     |
| `POSTGRES_HOST`             | Postgres URL of the DB host to connect to          | Y         |                     |
| `POSTGRES_USER`             | Postgres user to connect as                        | Y         |                     |
| `POSTGRES_PASSWORD_FILE`    | File holding the postgres password                 | Y         |                     |
| `CLOUD_STORAGE_BUCKET_FILE` | File holding the name of the Cloud Storage bucket  | Y         |                     |
| `CLOUD_STORAGE_KEY_FILE`    | File holding the key used to access Cloud Storage  | Y         |                     |
| `BACKUP_CRON_SCHEDULE`      | Cron schedule defining how often to run the backup | N         | `0 0 * * *` (Daily) |

Generally the `_FILE` variables will point to docker secret paths (e.g. `/run/secrets/postgres_password`).

## Setting up Google Cloud

- Create a new service account specifically for running backups.
- Create a new storage bucket for the backups
- Grant the following roles for the service account on the bucket:
  - If using Object Versioning, then "Storage Legacy Bucket Writer"
  - If not, then "Storage Object Creator"

### Object Versioning

Cloud Storage supports [Object Versioning](https://cloud.google.com/storage/docs/object-versioning), which lets you upload multiple objects under the same name. This makes it easy to do stuff like "Retain last x backups". The backup script will automatically check if your bucket has versioning enabled, and if so, it will always upload files under the same name. If not, each file name will include the date/time.

To enable object versioning, [see here](https://cloud.google.com/storage/docs/gsutil/commands/versioning).

## Running the backup manually

Exec into the backup container, then run

```sh
/app/backup.sh
```

## Restoring from a backup

Get the file name of the backup you want to restore from. Then run:

```sh
export file_name=<file_name>
export db=<db>
cd /root
gsutil cp gs://$(cat $CLOUD_STORAGE_BUCKET_FILE)/$file_name
tar xzvf $file_name
PGPASSWORD=$(cat $POSTGRES_PASSWORD_FILE) psql -h $POSTGRES_HOST -U $POSTGRES_USER -c "CREATE DATABASE $db;" # If necessary
PGPASSWORD=$(cat $POSTGRES_PASSWORD_FILE) psql -h $POSTGRES_HOST -U $POSTGRES_USER $db < backups/$db.bak
```
