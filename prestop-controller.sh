#!/bin/sh -e

PID=$(pgrep -f "Dapp_name=uReplicator-Controller" || true)
if [ -n "$PID" ]; then
 kill ${PID}
fi