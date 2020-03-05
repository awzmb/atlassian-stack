FROM openjdk:8-jdk-alpine

ARG BAMBOO_VERSION=6.7.3
ARG DOWNLOAD_URL=https://www.atlassian.com/software/bamboo/downloads/binary/atlassian-bamboo-${BAMBOO_VERSION}.tar.gz

ENV RUN_USER            daemon
ENV RUN_GROUP           daemon
ENV BAMBOO_JMS_CONNECTION_PORT=54663

# https://confluence.atlassian.com/doc/confluence-home-and-other-important-directories-590259707.html
ENV BAMBOO_HOME          /opt/atlassian/bamboo-data
ENV BAMBOO_INSTALL_DIR   /opt/atlassian/bamboo-install

VOLUME ["${BAMBOO_HOME}"]

# Expose HTTP and Synchrony ports
EXPOSE 8085
EXPOSE $BAMBOO_JMS_CONNECTION_PORT

WORKDIR $BAMBOO_HOME

RUN apk add --no-cache curl git bash procps openssl maven

COPY entrypoint.sh /entrypoint.sh
RUN chmod 777 /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

COPY . /tmp

RUN mkdir -p ${BAMBOO_INSTALL_DIR} \
    && curl -L --silent  ${DOWNLOAD_URL} | tar -xz --strip-components=1 -C "$BAMBOO_INSTALL_DIR" \
    && chown -R ${RUN_USER}:${RUN_GROUP} ${BAMBOO_INSTALL_DIR}/

RUN echo "bamboo.home=${BAMBOO_HOME}" > $BAMBOO_INSTALL_DIR/atlassian-bamboo/WEB-INF/classes/bamboo-init.properties

RUN sed -i -e 's/-Xms\([0-9]\+[kmg]\) -Xmx\([0-9]\+[kmg]\)/-Xms\${JVM_MINIMUM_MEMORY:=\1} -Xmx\${JVM_MAXIMUM_MEMORY:=\2} \${JVM_SUPPORT_RECOMMENDED_ARGS} -Dconfluence.home=\${BAMBOO_HOME}/g' ${BAMBOO_INSTALL_DIR}/bin/setenv.sh \
    && sed -i -e 's/port="8085"/port="8085" secure="${catalinaConnectorSecure}" scheme="${catalinaConnectorScheme}" proxyName="${catalinaConnectorProxyName}" proxyPort="${catalinaConnectorProxyPort}"/' ${BAMBOO_INSTALL_DIR}/conf/server.xml  \
    && sed -i -e 's/Context path=""/Context path="${catalinaContextPath}"/' ${BAMBOO_INSTALL_DIR}/conf/server.xml
