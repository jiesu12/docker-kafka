FROM jiesu/alpine-arm

RUN apk --no-cache add openjdk8-jre supervisor bash

RUN addgroup -g 1000 jie && adduser -D -H -G jie -s /bin/false -u 1000 jie

# Set supervisor
RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

ENV DATA /data
ENV LOG /log

VOLUME ${DATA}
VOLUME ${LOG}

RUN chown jie:jie ${DATA}
RUN chown jie:jie ${LOG}

COPY kafka_2.11-2.0.0 /kafka_2.11-2.0.0
RUN chown -R jie:jie /kafka_2.11-2.0.0
RUN sed -i 's/^log.dirs=.*/log.dirs=\/data\/kafka/' /kafka_2.11-2.0.0/config/server.properties
RUN sed -i 's/^dataDir=.*/dataDir=\/data\/zookeeper/' /kafka_2.11-2.0.0/config/zookeeper.properties

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

EXPOSE 2181

