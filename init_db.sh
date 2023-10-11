#!/bin/bash

# Use environment variables or set defaults
: "${RESET_DB:=false}"
: "${POSTGRES_DB:=espionox}"
: "${POSTGRES_USER:=root}"
: "${POSTGRES_PASSWORD:=strawhat.jury.steamboat.mother}"

DB_URL="postgres://${POSTGRES_USER}:${POSTGRES_PASSWORD}@${HOST}:${PORT}/${POSTGRES_DB}"

# Function to check if PostgreSQL is ready
wait_for_postgres() {
    until psql -h "${HOST}" -p "${PORT}" -U "${POSTGRES_USER}" -c '\q'; do
        echo "PostgreSQL is unavailable - sleeping"
        sleep 1
    done
    echo "PostgreSQL is up - executing command"
}

# Wait for PostgreSQL to be ready
# wait_for_postgres

if [ "${RESET_DB}" = "true" ]; then
    # Execute psql commands to drop existing database, create a new one, and create user
    echo "Creating database: $POSTGRES_DB with User: $POSTGRES_USER and Password: $POSTGRES_PASSWORD" 
    psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
        DROP DATABASE IF EXISTS "$POSTGRES_DB";
        CREATE DATABASE "$POSTGRES_DB";
        ALTER DATABASE "$POSTGRES_DB" OWNER TO "$POSTGRES_USER";
EOSQL

    echo "Database reset complete."
else
    echo "Database reset skipped. Use RESET_DB=true to reset the database."
fi

         # CREATE USER "$POSTGRES_USER" WITH PASSWORD '$POSTGRES_PASSWORD';
