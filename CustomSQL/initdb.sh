#!/bin/bash

# Wait 60 seconds for SQL Server to start up by ensuring that 
# Calling SQLCMD does not return an error code, which will ensure that sqlcmd is accessible
# and that system and user databases return "0" which means all databases are in an "online" state
# https://docs.microsoft.com/en-us/sql/relational-databases/system-catalog-views/sys-databases-transact-sql?view=sql-server-2017 

# Local variables
DBSTATUS=1
ERRCODE=1
i=0

# Checking database status, elapsed time and error code
while [[ $DBSTATUS -ne 0 ]] && [[ $i -lt 60 ]] && [[ $ERRCODE -ne 0 ]]; do
	i=$i+1
	#DBSTATUS=$(/opt/mssql-tools/bin/sqlcmd -h -1 -t 1 -U sa -P $SA_PASSWORD -Q "SET NOCOUNT ON; SELECT SUM(state) FROM sys.databases")
    DBSTATUS=$(sqlcmd -U SA -h -1 -t 1 -Q "SET NOCOUNT ON; SELECT SUM(state) FROM sys.databases")
	ERRCODE=$?
	sleep 1
done

# Exiting container with error
if [ $DBSTATUS -ne 0 ] OR [ $ERRCODE -ne 0 ]; then 
	echo "SQL Server took more than 60 seconds to start up or one or more databases are not in an ONLINE state"
	exit 1
fi

if [ ! -f /tmp/db-initialized ]
then

    # Loading scripts
    scripts=`ls /tmp/*.sql`

    # Run the setup script to create the DB and the schema in the DB
    for script in $scripts
    do
        echo -e "Processing script: $script ..."
        echo -e "======================================================\n"
        #/opt/mssql-tools/bin/sqlcmd -U sa -P $SA_PASSWORD -l 30 -e -i $script
        sqlcmd -U SA -l 30 -e -i $script
        touch /tmp/db-initialized
    done
        echo -e "\nAll scripts have been executed."
else

    # Wait for the SQL Server to start
    echo -e "\nSQL Server is starting, DBs are already initialized\n\n"
fi
# End of script