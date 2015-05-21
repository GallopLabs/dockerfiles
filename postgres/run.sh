#!/usr/bin/env bash

# Based off github/sameersbn/docker-postgresql start script
# this image will primarily be used for development and my
# needs are pretty narrow

PG_HOME="/var/lib/postgresql"
PG_BINDIR="/usr/lib/postgresql/9.3/bin"
PG_CONFDIR="/etc/postgresql/9.3/main"
PG_DATADIR="${PG_HOME}/9.3/main"

DB_NAME=${DB_NAME:-postgres}
DB_USER=${DB_USER:-postgres}
DB_PASS=${DB_PASS:-postgres}

chown -R postgres:postgres /var/lib/postgresql

# disable ssl
sed 's/ssl = true/#ssl = true/' -i ${PG_CONFDIR}/postgresql.conf

# allow connections from any host
cat >> ${PG_CONFDIR}/pg_hba.conf <<EOF
host    all    all    0.0.0.0/0    md5
EOF

# listen on all addresses
cat >> ${PG_CONFDIR}/postgresql.conf <<EOF
listen_addresses = '*'
EOF

if [ ! -d ${PG_DATADIR} ]; then
  echo "Bootstrapping PostgreSQL database..."
  su postgres -c "${PG_BINDIR}/postgres -H ${PG_BINDIR}/initdb --pgdata=${PG_DATADIR} \
    --username=postgres --encoding=unicode --auth=trust" >/dev/null
fi

echo "Creating user \"${DB_USER}\"..."
echo "CREATE ROLE ${DB_USER} with LOGIN CREATEDB SUPERUSER PASSWORD '${DB_PASS}';" | su postgres -c "${PG_BINDIR}/postgres --single \
  -D ${PG_DATADIR} -c config_file=${PG_CONFDIR}/postgresql.conf" >/dev/null

echo "Creating database \"${DB_NAME}\"..."
echo "CREATE DATABASE ${DB_NAME};" | su postgres -c "${PG_BINDIR}/postgres --single \
  -D ${PG_DATADIR} -c config_file=${PG_CONFDIR}/postgresql.conf" >/dev/null

echo "Granting privileges to database \"${DB_NAME}\" to user \"${DB_USER}\"..."
echo "GRANT ALL PRIVILEGES ON DATABASE ${DB_NAME} to ${DB_USER};" | su postgres -c "${PG_BINDIR}/postgres --single \
  -D ${PG_DATADIR} -c config_file=${PG_CONFDIR}/postgresql.conf" >/dev/null

echo "Installing PostgreSQL extensions..."
echo "CREATE EXTENSION hstore;" | su postgres -c "${PG_BINDIR}/postgres --single ${DB_NAME} \
  -D ${PG_DATADIR} -c config_file=${PG_CONFDIR}/postgresql.conf" >/dev/null
echo "CREATE EXTENSION \"uuid-ossp\";" | su postgres -c "${PG_BINDIR}/postgres --single ${DB_NAME} \
  -D ${PG_DATADIR} -c config_file=${PG_CONFDIR}/postgresql.conf" >/dev/null

echo "Starting PostgreSQL server..."
su postgres -c '/usr/lib/postgresql/9.3/bin/postgres -D /var/lib/postgresql/9.3/main -c config_file=/etc/postgresql/9.3/main/postgresql.conf'
