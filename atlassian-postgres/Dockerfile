FROM ubuntu:16.04

ENV POSTGRES_VERSION 9.6
ENV POSTGRES_USER atlassian 
ENV POSTGRES_PASSWORD atlassian

# Add the PostgreSQL PGP key to verify their Debian packages.
# It should be the same key as https://www.postgresql.org/media/keys/ACCC4CF8.asc
RUN apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8

# Add PostgreSQL's repository.
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main" > /etc/apt/sources.list.d/pgdg.list

# Install ``python-software-properties``, ``software-properties-common`` and PostgreSQL 9.6
#  There are some warnings (in red) that show up during the build. You can hide
#  them by prefixing each apt-get statement with DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
  && apt-get install -y wget python-software-properties software-properties-common postgresql-$POSTGRES_VERSION postgresql-client-$POSTGRES_VERSION postgresql-contrib-$POSTGRES_VERSION

# Create backup folder
RUN mkdir -p /data && chown -R postgres:postgres /data

USER postgres

# Adjust PostgreSQL configuration so that remote connections to the
# database are possible.
RUN echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/${POSTGRES_VERSION}/main/pg_hba.conf

# Create a PostgreSQL role named ``docker`` with ``docker`` as the password and
# then create a database `docker` owned by the ``docker`` role.
# Note: here we use ``&&\`` to run commands one after the other - the ``\``
#       allows the RUN command to span multiple lines.
RUN /etc/init.d/postgresql start \
    && psql --command "CREATE USER ${POSTGRES_USER} WITH SUPERUSER PASSWORD '${POSTGRES_PASSWORD}';" \
    && createdb -O atlassian atlassian \
    && createdb -O atlassian bamboo \ 
    && createdb -O atlassian bitbucket \
    && createdb -O atlassian confluence \
    && createdb -O atlassian crowd \
    && createdb -O atlassian jira

USER postgres

# And add ``listen_addresses`` to ``postgresql.conf``
RUN echo "listen_addresses='*'" >> /etc/postgresql/${POSTGRES_VERSION}/main/postgresql.conf

# Expose the PostgreSQL and NodeJS port
EXPOSE 5432

# Add VOLUMEs to allow backup of config, logs and databases
VOLUME  ["/var/lib/postgresql"]

RUN chmod -R 700 /var/lib/postgresql/9.6/main

# Set the default command to run when starting the container
CMD ["/usr/lib/postgresql/9.6/bin/postgres", "-D", "/var/lib/postgresql/9.6/main", "-c", "config_file=/etc/postgresql/9.6/main/postgresql.conf"]
