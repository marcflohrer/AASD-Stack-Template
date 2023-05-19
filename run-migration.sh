. .env

cd Data/Generated/ && find . ! -name . -prune ! -wholename ../Models -exec rm {} \; && cd ../..
docker compose -f docker-compose-dbmigrate.yml up --build --remove-orphans 
