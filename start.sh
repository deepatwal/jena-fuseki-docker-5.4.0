#!/bin/sh
set -e

# Run the text indexer
# java -cp fuseki-server.jar jena.textindexer -desc=/fuseki/run/config.ttl

# Start the Fuseki server
java -jar fuseki-server.jar --config /fuseki/run/config.ttl
