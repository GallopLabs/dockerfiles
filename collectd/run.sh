#!/bin/sh

CONFIG_FILE=${CONFIG_FILE:-/etc/collectd/collectd.conf}
COLLECTD_PROXY=${COLLECTD_PROXY:-proxy}

sed -i "s/%COLLECTD_PROXY%/${COLLECTD_PROXY}/" ${CONFIG_FILE}

exec collectd -f -C ${CONFIG_FILE}
