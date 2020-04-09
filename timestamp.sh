#!/usr/bin/env sh

TIMESTAMP="$(date +%s%N)"
FILE='/tmp/bavice.timestamp'
CONSUMER='telegraf'

echo "$TIMESTAMP" > "$FILE"
chown "$CONSUMER":"$CONSUMER" "$FILE"
