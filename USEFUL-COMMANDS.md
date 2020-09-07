## Clean ups

Clean all cached local content - `docker system prune -a`

# POI

## Build poi

`cd src/poi`

`docker build . -t poi:1.0`

## Start poi

Stop Container - `docker stop poi`

Remove container - `docker rm poi`

Start Container - `docker run --name poi -p 8080:80 poi:1.0`

Run docker image as daemon (in background): `docker run -d --name poi -p 8080:80 poi:1.0`

## Run with env for disabled SSL

docker run -d --name pio -p 8080:80 poi -e ASPNETCORE_ENVIRONMENT=Local poi

## Create docker network

`docker network create openhack`

## Create sql server:

1. Start SQL Server: `docker run --network openhack --name sqlserver -e ACCEPT_EULA='Y' -e SA_PASSWORD='OpenHack12345' -p 1433:1433 --hostname=sqlserver -d mcr.microsoft.com/mssql/server:2017-latest`
2. Create database: `docker exec -it sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P "OpenHack12345" -Q 'CREATE DATABASE mydrivingDB'`
  

## Start data loader:

`docker run --network openhack --name openhack -e SQLFQDN=sqlserver -e SQLUSER=SA -e SQLPASS=OpenHack12345 -e SQLDB=mydrivingDB -d openhack/data-load:v1`

## Start POI again

Stop existing POI: `docker stop poi`

Remove POI: `docker rm poi`

Start POI with environment variables: `docker run -d --name poi -p 8080:80 -e ASPNETCORE_ENVIRONMENT=Local --network openhack -e SQL_PASSWORD=OpenHack12345 -e SQL_DBNAME=mydrivingDB -e SQL_USER=SA -e SQL_SERVER=sqlserver poi:1.0`
 
Check the logs: `docker logs poi`