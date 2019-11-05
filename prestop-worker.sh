#!/bin/sh -e

PID=$(pgrep -f "Dapp_name=uReplicator-Worker" || true)
if [ -n "$PID" ]; then
 kill ${PID}
fi