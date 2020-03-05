FROM openjdk:8-jdk-alpine

ARG JIRA_VERSION=8.0.2
ARG DOWNLOAD_URL=http://www.atlassian.com/software/jira/downloads/binary/atlassian-jira-software-${JIRA_VERSION}.tar.gz

ENV RUN_USER            daemon
ENV RUN_GROUP           daemon

# https://confluence.atlassian.com/doc/confluence-home-and-other-important-directories-590259707.html
ENV JIRA_HOME          /opt/atlassian/jira-data
ENV JIRA_INSTALL_DIR   /opt/atlassian/jira-install

VOLUME ["${JIRA_HOME}"]

# Expose HTTP port
EXPOSE 8080

WORKDIR $JIRA_HOME

RUN apk add --no-cache wget curl bash ttf-dejavu libc6-compat

COPY entrypoint.sh /entrypoint.sh
RUN chmod 777 /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

COPY . /tmp

RUN mkdir -p ${JIRA_INSTALL_DIR} \
    && curl -L --silent  ${DOWNLOAD_URL} | tar -xz --strip-components=1 -C "$JIRA_INSTALL_DIR" \
    && chown -R ${RUN_USER}:${RUN_GROUP} ${JIRA_INSTALL_DIR}/

RUN sed -i -e 's/-Xms\([0-9]\+[kmg]\) -Xmx\([0-9]\+[kmg]\)/-Xms\${JVM_MINIMUM_MEMORY:=\1} -Xmx\${JVM_MAXIMUM_MEMORY:=\2} \${JVM_SUPPORT_RECOMMENDED_ARGS} -Djira.home=\${JIRA_HOME}/g' ${JIRA_INSTALL_DIR}/bin/setenv.sh \
    && sed -i -e 's/port="8080"/port="8080" secure="${catalinaConnectorSecure}" scheme="${catalinaConnectorScheme}" proxyName="${catalinaConnectorProxyName}" proxyPort="${catalinaConnectorProxyPort}"/' ${JIRA_INSTALL_DIR}/conf/server.xml  \
    && sed -i -e 's/Context path=""/Context path="${catalinaContextPath}"/' ${JIRA_INSTALL_DIR}/conf/server.xml
