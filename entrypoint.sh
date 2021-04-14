#!bin/bash
set -e

# remove potentially existing PID file
rm -f /myapp/tmp/pids/server.pid

# execute what's set as CMD in Dockerfile
exec "$@"
