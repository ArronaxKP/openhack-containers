docker network create openhack

docker run -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=OpenHack12345' -p 1433:1433 -d mcr.microsoft.com/mssql/server:2017-latest

docker run --network openhack -e SQLFQDN=localhost -e SQLUSER=SA -e SQLPASS=OpenHack12345 -e SQLDB=mydrivingDB -d openhack/data-load:v1
