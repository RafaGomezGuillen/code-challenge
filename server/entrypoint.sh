#!/bin/sh
set -e
sleep 1

echo "=> Executing migrations..."
bundle exec rails db:migrate || bundle exec rails db:setup

echo "=> Executing seeds ..."
bundle exec rails db:seed || true

exec "$@"
