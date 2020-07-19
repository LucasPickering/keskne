#!/bin/sh
# https://github.com/mrts/docker-postgresql-multiple-databases

set -u


echo "Creating GDLK database"
database=$GDLK_DB
user=$GDLK_DB
password=$GDLK_DB_PASSWORD

# Create the new user and DB.
# Then, set up restricted permissions for the user on the DB. They should have
# full read/write access on all tables, but can't make schema changes.
echo "  Creating user '$database' and database '$database'"
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    CREATE USER $user WITH PASSWORD '$password';
    CREATE DATABASE $database;

    \c $database
    REVOKE CONNECT ON DATABASE $database FROM PUBLIC;
    GRANT CONNECT ON DATABASE $database TO $user;

    REVOKE ALL ON SCHEMA public FROM PUBLIC;
    GRANT USAGE ON SCHEMA public TO PUBLIC;

    ALTER DEFAULT PRIVILEGES
        IN SCHEMA public
        GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO $user;
EOSQL
echo "  Done"
