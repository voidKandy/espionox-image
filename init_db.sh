#!/bin/bash

# Use environment variables or set defaults
: "${RESET_DB:=false}"
: "${POSTGRES_DB:=espionox}"
: "${POSTGRES_USER:=root}"
: "${POSTGRES_PASSWORD:=strawhat.jury.steamboat.mother}"

# Function to check if PostgreSQL is ready
wait_for_postgres() {
    until psql -h "${HOST}" -p "${PORT}" -U "${POSTGRES_USER}" -c '\q'; do
        echo "PostgreSQL is unavailable - sleeping"
        sleep 1
    done
    echo "PostgreSQL is up - executing command"
}

# Wait for PostgreSQL to be ready (Uncomment if needed)
# wait_for_postgres

if [ "${RESET_DB}" = "true" ]; then
    psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
        DROP DATABASE IF EXISTS "$POSTGRES_DB";
EOSQL
    echo "$POSTGRES_DB database dropped"
fi

# Execute psql commands to create a new database and apply migrations
echo "Creating database: $POSTGRES_DB with User: $POSTGRES_USER and Password: $POSTGRES_PASSWORD"
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE DATABASE "$POSTGRES_DB";
    ALTER DATABASE "$POSTGRES_DB" OWNER TO "$POSTGRES_USER";
EOSQL

# if [ $? -ne 0 ]; then
#     echo "Error creating database. Exiting."
#     exit 1
# fi

echo "Running up migrations..."
for migration_script in /docker-entrypoint-initdb.d/migrations/*.up.sql; do
    echo "Applying migration: $migration_script"
    psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" < "$migration_script"

    if [ $? -ne 0 ]; then
        echo "Error applying migration. Exiting."
        exit 1
    fi
done

echo "Up migrations complete."
