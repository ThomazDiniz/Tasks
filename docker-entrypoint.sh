#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /app/tmp/pids/server.pid

# Ensure we're in the app directory
cd /app

# Verify Rails application files exist
if [ ! -f "config/application.rb" ]; then
  echo "Error: config/application.rb not found. This doesn't appear to be a Rails application."
  exit 1
fi

# Wait for database to be ready
echo "Waiting for database to be ready..."
for i in {1..30}; do
  if bundle exec rake db:version 2>/dev/null; then
    echo "Database is ready!"
    break
  fi
  if [ $i -eq 30 ]; then
    echo "Creating database..."
    bundle exec rake db:create || true
  fi
  sleep 2
done

# Run database migrations
echo "Running database migrations..."
bundle exec rake db:migrate || echo "Migration failed or already up to date"

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"

