FROM ubuntu:bionic

ENV DATA /data
ENV LOG /log
ENV KAFKA_HOME /kafka_2.11-2.0.0

VOLUME ${DATA} ${LOG}

RUN apt-get update && \
apt-get install -y --no-install-recommends openjdk-8-jre supervisor && \
ln -snf /usr/share/zoneinfo/America/Chicago /etc/localtime && echo 'America/Chicago' > /etc/timezone && \
addgroup --gid 1000 jie && useradd --no-create-home --gid 1000 --shell /bin/false --uid 1000 jie && \
apt-get -y autoremove && apt-get -y clean && \
rm -rf /var/lib/apt/lists/* && rm -rf /tmp/*

# Set supervisor
RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /supervisord.conf

COPY kafka_2.11-2.0.0 ${KAFKA_HOME}
RUN chown -R jie:jie ${KAFKA_HOME} && \
sed -i 's/KAFKA_JVM_PERFORMANCE_OPTS=.*/KAFKA_JVM_PERFORMANCE_OPTS="-client -XX:+UseParNewGC -XX:+UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled -XX:+CMSScavengeBeforeRemark -XX:+DisableExplicitGC -Djava.awt.headless=true"/' ${KAFKA_HOME}/bin/kafka-run-class.sh && \
sed -i 's/^dataDir=.*/dataDir=\/data\/zookeeper/' ${KAFKA_HOME}/config/zookeeper.properties && \
sed -i 's/-Xmx512M -Xms512M/-Xmx256M -Xms128M/' ${KAFKA_HOME}/bin/zookeeper-server-start.sh && \
sed -i 's/^log.dirs=.*/log.dirs=\/data\/kafka/' ${KAFKA_HOME}/config/server.properties && \
sed -i 's/-Xmx1G -Xms1G/-Xmx256M -Xms128M/' ${KAFKA_HOME}/bin/kafka-server-start.sh

COPY start.sh /start.sh
RUN chmod +x start.sh

CMD ["/start.sh"]

EXPOSE 2181 9092

