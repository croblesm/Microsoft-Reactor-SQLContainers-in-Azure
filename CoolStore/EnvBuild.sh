# Notes
# # https://aws.amazon.com/rds/?trk=ps_a131L0000058UA5QAM&trkCampaign=pac_paidsearch_q4109_RDS_PDP_adgroups&sc_channel=ps&sc_campaign=pac_1019_paidsearch_US_OpenSource_nonbrand_prosp_database&sc_outcome=PaaS_Digital_Marketing&sc_geo=NAMER&sc_country=US&sc_publisher=Google&sc_content=database&sc_medium=PAC-PaaS-P|PS-GO|Non-Brand|Desktop|PA|Database|RDS|US|EN|Text&s_kwcid=AL!4422!3!433618291197!b!!g!!%2Bdatabases&ef_id=Cj0KCQjwyJn5BRDrARIsADZ9ykH3apbmdzVwY-in54e8n__PHSwZe-Djj2d3HjdfGgSAkbBL-TuXX8EaAuZbEALw_wcB:G:s&s_kwcid=AL!4422!3!433618291197!b!!g!!%2Bdatabases
# https://www.tutorialspoint.com/dbms/dbms_overview.htm
# https://docs.microsoft.com/en-us/dotnet/architecture/microservices/multi-container-microservice-net-applications/database-server-container
# Durability (data persitency)
# Connectivity
# High availability
# Reliability
# Scalability
# Security
# Isolation
# Consistency
# Data dependency

docker build ./mssql-aspcore-example-db/ -t "tigervin/mssql-aspcore-example-db"

cd CoolStore/app/
docker build . -t cool-store-web -f Dockerfile

docker run \
--name cool-store-db \
--hostname cool-store-db \
--env 'ACCEPT_EULA=Y' \
--env 'MSSQL_SA_PASSWORD=_SqLr0ck5_' \
--publish 1500:1433 \
--detach mcr.microsoft.com/mssql/server:2019-CU5-ubuntu-18.04

sa_password="_SqLr0ck5_";
sqlcmd -S localhost,1500 -U SA -P $sa_password -d master -i ./db/db-init.sql
docker commit 41e4ebc1771a cool-store-db

cd "/Users/carlos/Documents/Microsoft-Reactor/CoolStore"
docker-compose up
docker-compose down

resource_group=Microsoft-Reactor;
acr_name=dbamastery;
acr_repo_db=cool-store-db;
acr_repo_web=cool-store-web;
location=westus;

az acr list --resource-group $resource_group -o table

# Getting image id
image_id_db=`docker images | grep cool-store-db | awk '{ print $3 }' | head -1`
image_id_web=`docker images | grep cool-store-web | awk '{ print $3 }' | head -1`


# Tagging image with private registry and build number
# ACR FQN = dbamastery.azurecr.io/mssqltools-alpine:2.0
docker tag $image_id_db $acr_name.azurecr.io/$acr_repo_db:1.0
docker tag $image_id_web $acr_name.azurecr.io/$acr_repo_web:1.0


docker images
# Pushing image to ACR (dbamastery) - mssqltools-alpine repository
# Make sure to check ACR authentication and login process with Docker first
docker push $acr_name.azurecr.io/$acr_repo_db:1.0
docker push $acr_name.azurecr.io/$acr_repo_web:1.0