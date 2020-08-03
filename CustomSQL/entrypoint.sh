#!/bin/bash

# Start the script to create the DB and user
/tmp/initdb/initdb.sh &

# Start SQL Server
/opt/mssql/bin/sqlservr