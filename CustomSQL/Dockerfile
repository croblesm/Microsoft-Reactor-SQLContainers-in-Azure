# Customized SQL Server Docker image
# From SQL Server 2019 CU4 Ubuntu 18.04 image
FROM mcr.microsoft.com/mssql/server:2019-CU4-ubuntu-18.04

# Labels
LABEL maintainer="crobles@dbamastery.com"
LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.name="Custom-SQL"
LABEL org.label-schema.description="Customized SQL Server image"
LABEL org.label-schema.url="http://dbamastery.com"

# Changing context to root user
USER root

# Create a config directory, change owner to mssql (group id)
RUN mkdir -p /tmp/initdb && chown 10001 /tmp/initdb

# Copy initdb, entrypoint and SQL files to initdb folder
COPY . /tmp/initdb

# Changing permissions to initdb and entrypoint
RUN chmod +x /tmp/initdb/initdb.sh /tmp/initdb/entrypoint.sh

# Changing context to mssql user
USER mssql

# SQL Server environment variables
ENV WAIT_SQL=30
ENV ACCEPT_EULA=Y
ENV SA_PASSWORD='_SqLr0ck5_'
ENV SQLCMDPASSWORD=${SA_PASSWORD}
ENV PATH=$PATH:/opt/mssql-tools/bin

# Executing entry point script
CMD ["sh","-c","/tmp/initdb/entrypoint.sh ${WAIT_SQL}"]