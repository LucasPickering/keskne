#!/bin/sh
# https://github.com/mrts/docker-postgresql-multiple-databases

set -e
set -u

function create_user_and_database() {
    local database=$1
    local password=$(echo $2) # Read pw from the file
    echo "  Creating user '$database' and database '$database'"
    psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
        CREATE USER $database WITH PASSWORD '$password';
        CREATE DATABASE $database;
        GRANT ALL PRIVILEGES ON DATABASE $database TO $database;
EOSQL
    echo "  Done"
}

echo "Creating users and databases"
create_user_and_database $MBTA_DB $MBTA_DB_PASSWORD_FILE
create_user_and_database $RPS_DB $RPS_DB_PASSWORD_FILE
