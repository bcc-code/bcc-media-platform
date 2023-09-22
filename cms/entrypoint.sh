#!/bin/sh

/cloud_sql_proxy -instances brunstadtv:europe-west4:btv-sql-prod=tcp:localhost:1433 &

if [ -f .env ]; then
  export $(echo $(cat .env | sed 's/#.*//g'| xargs) | envsubst)
fi

node /directus/cli start
