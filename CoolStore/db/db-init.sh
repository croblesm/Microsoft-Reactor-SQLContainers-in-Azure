#wait for the SQL Server to come up
sleep 15s

#run the setup script to create the DB and the schema in the DB
sqlcmd -S localhost,1500 -U sa -P SApassword -d master -i db-init.sql