#!/bin/sh
# https://github.com/mrts/docker-postgresql-multiple-databases

set -u


echo "Creating GDLK database"
database=$GDLK_DB
password=$GDLK_DB_PASSWORD
echo "  Creating user '$database' and database '$database'"
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    CREATE USER $database WITH SUPERUSER PASSWORD '$password';
    CREATE DATABASE $database;
    GRANT ALL PRIVILEGES ON DATABASE $database TO $database;
    CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
    CREATE EXTENSION IF NOT EXISTS "unaccent";
EOSQL
echo "  Done"
