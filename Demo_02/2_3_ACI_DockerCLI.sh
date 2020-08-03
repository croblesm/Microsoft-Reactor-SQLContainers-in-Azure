# DEMO 2 - ACI Container from Docker CLI
# Part 3 - Docker CLI experience
#   1- Login to Azure
#   2- List existing Docker CLI contexts
#   3- Create ACI context called "Microsoft-Reactor"
#   4- Set Docker CLI context to ACI
#   5- Check Docker CLI context
#   6- Create SQL container
#   7- Check container status
#   8- Check container logs
#   9- Connect from local Azure Data Studio
#   10- Connect from local SQLCMD
#
# -----------------------------------------------------------------------------
# References:
#   https://www.docker.com/products/docker-desktop
#   https://www.docker.com/blog/running-a-container-in-aci-with-docker-desktop-edge/
#   https://www.docker.com/blog/shortening-the-developer-commute-with-docker-and-microsoft-azure/
#   https://docs.docker.com/engine/context/working-with-contexts/

# 0- Env variables | demo path
resource_group=Microsoft-Reactor;
aci_name=aci-sql-dev03;
cd ~/Documents/$resource_group/Demo_02;

# 0- Dowload latest Edge release for macOS, Linux or Windows
https://www.docker.com/products/docker-desktop

# 1- Login to Azure
docker login azure

# 2- List existing Docker CLI contexts
docker context ls

# 3- Create ACI context called "Microsoft-Reactor"
docker context create aci Microsoft-Reactor \
    --subscription-id a3729944-2d39-4be1-8251-0529dd60c431 \
    --resource-group Microsoft-Reactor \
    --location westus

# 4- Set Docker CLI context to ACI
docker context use Microsoft-Reactor

# 5- Check Docker CLI context
docker context ls

# 6- Create SQL container
docker run \
    --name aci-sql-dev03 \
    --env 'ACCEPT_EULA=Y' \
    --env 'MSSQL_SA_PASSWORD=_SqLr0ck5_' \
    --publish 1433:1433 \
    --cpus 2 \
    --memory 4096m \
    --detach mcr.microsoft.com/mssql/server:2019-CU4-ubuntu-18.04

# 7- Check container status
docker ps -a

# 8- Check container logs
docker logs aci-sql-dev03 -f

# 9- Connect from local Azure Data Studio
# --------------------------------------
# Azure Data Studio step
# --------------------------------------
# Connect to SQL Server container in ACI
# Show SQL instance dashboard

# 10- Connect from local SQLCMD
sa_password="_SqLr0ck5_";
server_name=`docker inspect $aci_name | grep "HostIP" | awk '{print $2}' | sed 's/\"//g'`
server_name=$(docker inspect $aci_name | jq -r ".Ports[0].HostIP")

# Executing queries
sqlcmd -S $server_name -U SA -P $sa_password -Q "set nocount on; select @@servername;"
sqlcmd -S $server_name -U SA -P $sa_password -Q "set nocount on; select name from sys.databases"

# 11- Docker compose?
docker compose up --project-name CoolStore
docker compose down --project-name CoolStore