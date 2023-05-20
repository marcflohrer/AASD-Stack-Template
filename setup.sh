. .env

cd AspNetAngularTemplate/Data/Migrations/ && find . ! -name . -prune ! -wholename ../Models -exec rm {} \; && cd ../../..
# create a variable DatabaseConnectionString for MSSQL and set password from .env file where the database ontainer name is db and database name is  master, user is sa and password is from .env file
DatabaseConnectionString="Server=db;Database=master;User=sa;Password=${DatabasePassword};TrustServerCertificate=True;"
dotnet user-secrets set ConnectionStrings:DefaultConnection "${DatabaseConnectionString};" --project .
docker compose -f docker-compose-dbmigrate.yml up --build --remove-orphans 
