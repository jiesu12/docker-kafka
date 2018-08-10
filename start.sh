#!/bin/bash

echo "advertised.host.name=${ADVERTISED_HOST}" >> ${KAFKA_HOME}/config/server.properties
echo "advertised.port=9092" >> ${KAFKA_HOME}/config/server.properties

/usr/bin/supervisord -n -c /supervisord.conf

