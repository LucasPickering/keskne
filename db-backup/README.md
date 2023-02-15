# postgres-backup

This is an image to periodically back up databases from a Mongo instance and/or a Postgres instance and upload the backups to a Google Cloud Storage bucket.

## Env Variables

Backup can be configured through a few env variables:

| Variable                 | Purpose                                             | Required? |
| ------------------------ | --------------------------------------------------- | --------- |
| `DATABASE_TYPE`          | `mongo` or `postgres`                               | Y         |
| `DATABASE_HOST`          | Hostname for the database server                    | Y         |
| `DATABASE_PORT`          | Port for the database server                        | N         |
| `DATABASE_NAME`          | Name of the database within the instance to back up | Y         |
| `DATABASE_USER`          | User to connect to the database as                  | N         |
| `DATABASE_PASSWORD_FILE` | File holding the database password                  | N         |
| `CLOUD_STORAGE_BUCKET`   | Cloud Storage bucket to save backups to             | Y         |
| `CLOUD_STORAGE_PREFIX`   | Prefix within the bucket to save backups to         | N         |
| `CLOUD_STORAGE_KEY_FILE` | File holding the key used to access Cloud Storage   | Y         |

TODO fix up docs

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

# Mongo

# Postgres
PGPASSWORD=$(cat $POSTGRES_PASSWORD_FILE) psql -h $POSTGRES_HOST -U $POSTGRES_USER -c "CREATE DATABASE $db;" # If necessary
PGPASSWORD=$(cat $POSTGRES_PASSWORD_FILE) psql -h $POSTGRES_HOST -U $POSTGRES_USER $db < backups/postgres/$db.bak
```
