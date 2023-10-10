#!/bin/bash

# Use environment variables or set defaults
: "${RESET_DB:=false}"
: "${POSTGRES_DB:=espionox}"
: "${POSTGRES_USER:=dev}"
: "${POSTGRES_PASSWORD:=strawhat.jury.steamboat.mother}"

if [ "${RESET_DB}" = "true" ]; then
    # Execute psql commands to drop existing database, create a new one, and create user
    psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
        DROP DATABASE IF EXISTS "$POSTGRES_DB";
        CREATE DATABASE "$POSTGRES_DB";
        CREATE USER "$POSTGRES_USER" WITH PASSWORD '$POSTGRES_PASSWORD';
        ALTER DATABASE "$POSTGRES_DB" OWNER TO "$POSTGRES_USER";
EOSQL

    echo "Database reset complete."
else
    echo "Database reset skipped. Use RESET_DB=true to reset the database."
fi

# Add your other schema setup statements here
