#!/bin/sh
# https://github.com/mrts/docker-postgresql-multiple-databases

set -u


echo "Creating RPS database"
database=$RPS_DB
user=$RPS_DB
password=$RPS_DB_PASSWORD
echo "  Creating user '$user' and database '$database'"
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    CREATE USER $user WITH PASSWORD '$password';
    CREATE DATABASE $database;
    GRANT ALL PRIVILEGES ON DATABASE $database TO $user;
EOSQL
echo "  Done"
