#!/bin/sh

set -e

# Removes the socket that Puma might have left behind when restarting docker-compose.
rm -f tmp/pids/server.pid

docker/setup-postgres.sh $DATABASE_HOST $DATABASE_NAME $DATABASE_USERNAME $DATABASE_PASSWORD

exec bundle exec padrino start -h 0.0.0.0
