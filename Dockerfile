FROM ankane/pgvector

COPY init_db.sh /docker-entrypoint-initdb.d/
# COPY create_db.sql /docker-entrypoint-initdb.d/
# COPY configure_db.sh /docker-entrypoint-initdb.d/

COPY postgresql.conf /etc/postgresql/postgresql.conf

WORKDIR /migrations

COPY migrations/*.sql /docker-entrypoint-initdb.d/migrations/
EXPOSE 5432

CMD ["postgres", "-c", "config_file=/etc/postgresql/postgresql.conf"]
