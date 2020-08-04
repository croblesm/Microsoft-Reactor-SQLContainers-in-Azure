#!/bin/bash

#==============================================================================
# Script name   : initdb.sh
# Description   : Script to deploy SQL scripts
# Author        : Carlos Robles
# Email         : crobles@dbamastery.com
# Twitter       : @dbamastery
# Date          : 20200801
# 
# Version       : 1.1
# Usage         : bash initdb.sh 30
#
# Notes         : 
#               crobles - 202008 - First version of this script
#==============================================================================

# Mapping env variables with local variables
wait_sql=$1

# Check if container was already created (Initialized)
if [ ! -f /tmp/initdb/db-init-1 ]
then
    # Wait for the SQL Server to start
    echo -e "\nWaiting $wait_sql seconds for SQL Server to start ⏳" | tee -a $log
    echo -e "===============================================\n\n" | tee -a $log
    sleep $wait_sql
        
    # Getting list of scripts
    scripts=`ls /tmp/initdb/*.sql`

    # Run the setup script to create the DB and the schema in the DB
    for script in $scripts
    do
        echo -e "\nProcessing script: $script ..."
        echo -e "======================================================\n"
        sqlcmd -U SA -l 30 -e -i $script
    done

    # End of script with success
    echo -e "\nThe scripts was successfully completed! 😁"
    echo -e "===============================================\n"
    touch /tmp/initdb/db-init-1
    exit 0

else
    # Wait for the SQL Server to start
    echo -e "Waiting $wait_sql for SQL Server to start\n\n" | tee -a $log
    sleep $wait_sql
fi