#!/bin/sh
# https://github.com/mrts/docker-postgresql-multiple-databases

set -e
set -u

function create_user_and_database() {
    local database=$1
    local password=$2
    echo "  Creating user '$database' and database '$database'"
    psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
        CREATE USER $database WITH PASSWORD '$password';
        CREATE DATABASE $database;
        GRANT ALL PRIVILEGES ON DATABASE $database TO $database;
EOSQL
    echo "  Done"
}

# This code below is untested. I guess we won't really know if it works until
# the next time the DB volume gets recreated

# Read each secret file into an env var
for f in ${SECRETS_DIR-"/run/secrets/"}*; do
    if [ -e "$f" ]; then
        echo "Reading \"$f\" into \"$f\""
        $f=$(cat $f) # Load the secret value
    fi
done
echo "Creating users and databases"
create_user_and_database $MBTA_DB $keskne_mbta_db_password
create_user_and_database $RPS_DB $keskne_rps_db_password
