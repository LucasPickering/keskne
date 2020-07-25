#!/bin/sh

set -e

# Default to daily
schedule=${BACKUP_CRON_SCHEDULE:-"0 0 * * *"}
echo "$schedule /app/backup.sh >> /var/log/backup.log" > /etc/crontab
crontab /etc/crontab
echo "Set backup schedule to \"$schedule\""

gcloud auth activate-service-account --key-file=$CLOUD_STORAGE_KEY_FILE

exec $@
