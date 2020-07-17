#!/bin/sh
# https://github.com/mrts/docker-postgresql-multiple-databases

set -u


echo "Creating RPS database"
database=$RPS_DB
password=$RPS_DB_PASSWORD
echo "  Creating user '$database' and database '$database'"
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    CREATE USER $database WITH PASSWORD '$password';
    CREATE DATABASE $database;
    GRANT ALL PRIVILEGES ON DATABASE $database TO $database;
EOSQL
echo "  Done"
