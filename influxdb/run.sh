#!/bin/sh

INFLUX=/opt/influxdb/influx
INFLUXD=/opt/influxdb/influxd
CONFIG_FILE=/etc/opt/influxdb/influxdb.conf

# Dynamically change the value of 'max-open-shards' to what 'ulimit -n' returns
sed -i "s/^max-open-shards.*/max-open-shards = $(ulimit -n)/" ${CONFIG_FILE}

exec ${INFLUXD} -config=${CONFIG_FILE}
