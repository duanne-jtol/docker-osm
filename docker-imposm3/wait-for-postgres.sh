#!/bin/sh
# wait-for-postgres.sh

set -e

cmd="$@"

until PGPASSWORD="$POSTGRES_PASS" psql -h "$POSTGRES_HOST" -U "$POSTGRES_USER" -d "$POSTGRES_DBNAME" -c '\q'; do
  >&2 echo "Postgres is unavailable - sleeping"
  sleep 1
done

>&2 echo "Postgres is up - executing command"
exec $cmd
