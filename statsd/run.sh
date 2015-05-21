#!/usr/bin/env bash

DEBUG=${DEBUG:-false}
DUMP_MESSAGES=${DUMP_MESSAGES:-false}

if [ ! -z $GRAPHITE_PORT_2003_TCP_ADDR ]; then
  export GRAPHITE_HOST="${GRAPHITE_PORT_2003_TCP_ADDR}"
fi

if [ ! -z $GRAPHITE_PORT_2003_TCP_PORT ]; then
  export GRAPHITE_PORT="${GRAPHITE_PORT_2003_TCP_PORT}"
fi

if [ ! -z $GRAPHITE_HOST ]; then
  cat > /opt/statsd/config.js <<EOF
{
  "port": 8125,
  "flushInterval": 60000,
  "debug": $DEBUG,
  "dumpMessages": $DUMP_MESSAGES,
  "backends": [
    "./backends/graphite"
  ],
  "graphiteHost": "$GRAPHITE_HOST",
  "graphitePort": $GRAPHITE_PORT
}
EOF
else
  cat > /opt/statsd/config.js <<EOF
{
  "port": 8125,
  "debug": $DEBUG,
  "dumpMessages": $DUMP_MESSAGES
}
EOF
fi

statsd /opt/statsd/config.js
