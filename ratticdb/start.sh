#!/usr/bin/env bash
set -e

if [ ! -z $POSTGRES_PORT_5432_TCP_ADDR ]; then
  export DATABASE_HOST="${POSTGRES_PORT_5432_TCP_ADDR}"
fi

if [ ! -z $POSTGRES_PORT_5432_TCP_PORT ]; then
  export DATABASE_PORT="${POSTGRES_PORT_5432_TCP_PORT}"
fi

cd /srv/RatticWeb
./generate_config.py > /srv/RatticWeb/conf/local.cfg
./manage.py syncdb --noinput && ./manage.py migrate --all
./manage.py collectstatic --noinput

/usr/bin/supervisord
