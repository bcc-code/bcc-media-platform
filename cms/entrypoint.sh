#!/bin/sh
./cloud_sql_proxy -instances brunstadtv:europe-west4:btv-sql-prod=tcp:localhost:1433 &
npx directus bootstrap
make schema-update
npx directus start
