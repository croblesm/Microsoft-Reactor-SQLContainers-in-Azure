#!/bin/bash

# Start SQL Server, then start the SQL script to restore DB and create objects
# The wait time depends on the environment
echo -e "\n======================================================"
echo -e "Starting SQL Server ..."
echo -e "======================================================\n"
/tmp/initdb/initdb.sh $1 & /opt/mssql/bin/sqlservr