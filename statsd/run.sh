#!/bin/sh
set -e

DEBUG=${DEBUG:-false}
DUMP_MESSAGES=${DUMP_MESSAGES:-false}
FLUSH_INTERVAL=${FLUSH_INTERVAL:-600}
REPEATER_PORT=${REPEATER_PORT:-8125}

if [ ! -z $GRAPHITE_PORT_2003_TCP_ADDR ]; then
  export GRAPHITE_HOST="${GRAPHITE_PORT_2003_TCP_ADDR}"
fi

if [ ! -z $GRAPHITE_PORT_2003_TCP_PORT ]; then
  export GRAPHITE_PORT="${GRAPHITE_PORT_2003_TCP_PORT}"
fi

case $1 in
graphite)
  if [ -z $GRAPHITE_HOST ]; then
    echo "Error: You must specify the GRAPHITE_HOST or link this image to a graphite container" >&2
    exit 1
  fi
  cat > /opt/statsd/config.js <<EOF
{
  "port": 8125,
  "debug": $DEBUG,
  "dumpMessages": $DUMP_MESSAGES,
  "flushInterval": $FLUSH_INTERVAL,
  "backends": [
    "./backends/graphite"
  ],
  "graphiteHost": "$GRAPHITE_HOST",
  "graphitePort": $GRAPHITE_PORT
}
EOF
  ;;
repeater)
  if [ -z $REPEATER_HOST ]; then
    echo "Error: You must specify the REPEATER_HOST"
    exit 1
  fi

  cat > /opt/statsd/config.js <<EOF
{
  "port": 8125,
  "debug": $DEBUG,
  "dumpMessages": $DUMP_MESSAGES,
  "flushInterval": $FLUSH_INTERVAL,
  "backends": [
    "./backends/repeater"
  ],
  "repeater": [
    {
      host: "$REPEATER_HOST",
      port: $REPEATER_PORT
    }
  ]
}
EOF
  ;;
*)
  cat > /opt/statsd/config.js <<EOF
{
  "port": 8125,
  "debug": $DEBUG,
  "dumpMessages": $DUMP_MESSAGES,
  "flushInterval": $FLUSH_INTERVAL
}
EOF
 ;;
esac

exec statsd /opt/statsd/config.js
