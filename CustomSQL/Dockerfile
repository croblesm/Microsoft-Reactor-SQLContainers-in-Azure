# Dockerfile
# From SQL Server 2019 CU4 Ubuntu image
FROM mcr.microsoft.com/mssql/server:2019-CU4-ubuntu-18.04

# Labels
LABEL maintainer="crobles@dbamastery.com"
LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.name="Custom-SQL"
LABEL org.label-schema.description="Customized SQL Server image"
LABEL org.label-schema.url="http://dbamastery.com"

# SQL Server environment variables
ENV ACCEPT_EULA=Y
ENV SA_PASSWORD='_SqLr0ck$_'
ENV SQLCMDPASSWORD=${SA_PASSWORD}
ENV PATH=$PATH:/opt/mssql-tools/bin

# Create a config directory
RUN mkdir -p /tmp/initdb
#WORKDIR /tmp/initdb

# Copy initdb, entrypoint and SQL files to initdb folder
COPY . /tmp/initdb

# Changing permissions to initdb and entrypoint
RUN chmod +x /tmp/initdb/initdb.sh /tmp/initdb/entrypoint.sh

# Executing entry point script
CMD ["sh","-c","/tmp/initdb/entrypoint.sh"]