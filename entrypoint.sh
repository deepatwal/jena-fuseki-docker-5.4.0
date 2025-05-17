#!/bin/sh
set -e

# Fix permissions on mounted volumes
chown -R fuseki:fuseki /fuseki/run /fuseki/tmp

# Execute the CMD
exec "$@"
