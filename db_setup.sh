#!/bin/bash
CONTAINER_NAME=postgres
DB_USER=studget
DB_PW=password
DB_NAME=studget

# apply initial db
docker exec -i $CONTAINER_NAME /bin/bash -c "PGPASSWORD=$DB_PW psql --username $DB_USER $DB_NAME" < databases/Initial_Database_Structure.sql

# apply migrations
for filename in `ls databases/migrations | sort -n`
 do
   echo "Execute Migration for: ${filename}"
   docker exec -i $CONTAINER_NAME /bin/bash -c "PGPASSWORD=$DB_PW psql --username $DB_USER $DB_NAME" < databases/migrations/${filename}
 done