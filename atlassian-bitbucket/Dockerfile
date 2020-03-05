FROM openjdk:8-jdk-alpine

ARG BITBUCKET_VERSION=6.1.2
ARG DOWNLOAD_URL=https://www.atlassian.com/software/stash/downloads/binary/atlassian-bitbucket-${BITBUCKET_VERSION}.tar.gz

ENV RUN_USER            daemon
ENV RUN_GROUP           daemon

# https://confluence.atlassian.com/doc/confluence-home-and-other-important-directories-590259707.html
ENV BITBUCKET_HOME          /opt/atlassian/bitbucket-data
ENV BITBUCKET_INSTALL_DIR   /opt/atlassian/bitbucket-install

VOLUME ["${BITBUCKET_HOME}"]

# Expose ports
EXPOSE 7990
#EXPOSE 7999

WORKDIR $BITBUCKET_HOME

RUN apk add --no-cache \
    wget \
    curl \
    bash \
    ttf-dejavu \
    libc6-compat \
    fontconfig \
    git \
    perl \
    wget \
    ca-certificates \
    gnupg \
    openssl \
    openssh \
    gzip \
    util-linux \
    su-exec \
    procps

COPY entrypoint.sh /entrypoint.sh
RUN chmod 777 /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

COPY . /tmp

RUN mkdir -p ${BITBUCKET_INSTALL_DIR} \
    && curl -L --silent ${DOWNLOAD_URL} | tar -xz --strip-components=1 -C "${BITBUCKET_INSTALL_DIR}" \
    && chown -R ${RUN_USER}:${RUN_GROUP} ${BITBUCKET_INSTALL_DIR}/ \
    && sed -i -e 's/^# umask/umask/' ${BITBUCKET_INSTALL_DIR}/bin/_start-webapp.sh
