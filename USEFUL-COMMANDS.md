## Clean ups

Clean all cached local content - `docker system prune -a`

# POI

## Build poi

Move to POI folder: `cd src/poi`

Build Poi application and tag with 1.0: `docker build . -t poi:1.0`

The commands above create a docker image with tag name `poi`

## Start poi

Start Container - `docker run --name poi -p 8080:80 poi`

## Run with env for disabled SSL

`docker run -d --name pio -p 8080:80 poi -e ASPNETCORE_ENVIRONMENT=Local poi`

## Create docker network

`docker network create openhack`

## Create sql server:

1. `docker run --network openhack --name sqlserver -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=OpenHack12345' -p 1433:1433 --hostname=sqlserver -d mcr.microsoft.com/mssql/server:2017-latest`
2. Create database:
   1.  https://docs.microsoft.com/en-us/sql/linux/quickstart-install-connect-docker?view=sql-server-2017&pivots=cs1-bash#create-a-new-database
       1.  `docker exec -it sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P "OpenHack12345" -Q 'CREATE DATABASE mydrivingDB`

## Start data loader:

`docker run --network openhack --name openhack -e SQLFQDN=sqlserver -e SQLUSER=SA -e SQLPASS=OpenHack12345 -e SQLDB=mydrivingDB -d openhack/data-load:v1`

# Start POI:
Stop Container - `docker stop poi`

Remove container - `docker rm poi`

Start POI with environment variables: `docker run -d --name poi -p 8080:80 -e ASPNETCORE_ENVIRONMENT=Local --network openhack -e SQL_PASSWORD=OpenHack12345 -e SQL_DBNAME=mydrivingDB -e SQL_USER=SA -e SQL_SERVER=sqlserver poi:1.0`

Check the logs: `docker logs poi`

`docker run --network openhack --name openhack -e SQLFQDN=sqlserver -e SQLUSER=SA -e SQLPASS=OpenHack12345 -e SQLDB=mydrivingDB -d openhack/data-load:v1`

Test if it's all working:
`curl -i -X GET 'http://localhost:8080/api/poi'`

More:

https://github.com/Azure-Samples/openhack-containers/tree/master/src/poi#testing


# Azure docker repo

## Docs
https://docs.microsoft.com/en-us/azure/container-registry/container-registry-get-started-docker-cli

registryoob9604.azurecr.io

Go to poi directory and execute:

`docker build -t registryoob9604.azurecr.io/tripinsights/poi:1.0 .`

and push it to our registry:

`docker push registryoob9604.azurecr.io/tripinsights/poi:1.0`