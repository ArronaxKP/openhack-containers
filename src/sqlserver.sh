docker network create openhack

docker run --network openhack -e SQLFQDN=localhost -e SQLUSER=openhack -e SQLPASS=openhack -e SQLDB=mydrivingDB openhack/data-load:v1