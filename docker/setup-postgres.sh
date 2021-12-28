#!/bin/sh

# Taken from https://docs.docker.com/compose/startup-order/

set -e

db_host="$1"
db_name="$2"
db_user="$3"
db_password="$4"

until PGPASSWORD="$db_password" psql -h "$db_host" -U "$db_user" -c '\q'; do
  >&2 echo "Database is unavailable - sleeping"
  sleep 1
done

if PGPASSWORD="password" psql -h "$db_host" -U "$db_user" -d "$db_name" -c "\q"; then
    echo "🐘 Database already exists: doing nothing"
else
    echo "🐘 Database does not exist: will create it"
    padrino rake ar:create ar:migrate
fi

backup_file="$PWD/backups/current.dump"

if [ -f $backup_file ]; then
  echo "Loading backup"
  PGPASSWORD="$db_password" pg_restore -Fc -h "$db_host" -U "$db_user" -d "$db_name" -O -x -1 -c "$backup_file"
  padrino rake ar:migrate
fi
