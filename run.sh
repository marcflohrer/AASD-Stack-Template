#!/bin/bash
. .env

#mkdir -p mssql/data
#dotnet build &
#dotnet user-secrets init 
#dotnet user-secrets set ConnectionStrings:DefaultConnection "${DatabaseConnectionString}" --project .
#dotnet user-secrets set ServiceWeltUser "${ServiceWeltUser}" --project .
#dotnet user-secrets set ServiceWeltPassword "${ServiceWeltPassword}" --project .
#dotnet user-secrets set ServiceWeltUrl "${ServiceWeltUrl}" --project .
# create a variable DatabaseConnectionString for MSSQL and set password from .env file where the container name is investordb and database name is  master, user is sa and password is from .env file
DatabaseContainerName="investordb"
DatabaseConnectionString="Server=${DatabaseContainerName};Database=master;User=sa;Password=${DatabasePassword};TrustServerCertificate=True;"
dotnet user-secrets set ConnectionStrings:DefaultConnection "${DatabaseConnectionString};" --project .
docker compose up --build --remove-orphans -d
#dotnet user-secrets clear
#docker system prune -f