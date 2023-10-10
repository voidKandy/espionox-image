FROM postgres:13

# COPY .env /etc/postgresql/.env

COPY init_db.sh /docker-entrypoint-initdb.d/

WORKDIR /migrations

COPY migrations/*.sql ./

EXPOSE 6987

CMD ["postgres"]
