#! /bin/bash
#

read -p "Are you sure? This *WILL* destroy any data in STA!" -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1 # handle exits from shell or function but don't exit interactive shell
fi

DEV=15432
STA=15433
PROD=15434

STA_PASS=$(gcloud --project=btv-platform-sta-2 secrets versions access latest --secret="postgres_builder_password")
PROD_PASS=$(gcloud --project=btv-platform-prod-2 secrets versions access latest --secret="postgres_builder_password")

# Add for dev:
# -instances btv-platform-dev-2:europe-west4:main-instance=tcp:localhost:$DEV 

cloud_sql_proxy -verbose -instances btv-platform-sta-2:europe-west4:main-instance=tcp:localhost:$STA -instances btv-platform-prod-2:europe-west4:main-instance=tcp:localhost:$PROD &
PROXY_PID=$!

# Wait for the proxy to connect
sleep 3

PGPASSWORD=$STA_PASS pg_dump -h localhost -p $STA -U builder -d directus -v -c --if-exists --table public.directus_* --schema public > directus_sta_tables.sql

PGPASSWORD=$PROD_PASS pg_dump -h localhost -p $PROD -U builder -d directus -v -c --if-exists --exclude-table public.directus_* --schema public > data.dump.sql

PGPASSWORD=$PROD_PASS pg_dump -h localhost -p $PROD -U builder -d directus -v -c --if-exists --table public.directus_files --schema public > images.dump.sql

PGPASSWORD=$STA_PASS psql -h localhost -p $STA -U builder -d directus < drop-schema.sql
PGPASSWORD=$STA_PASS psql -h localhost -p $STA -U builder -d directus < directus_sta_tables.sql
PGPASSWORD=$STA_PASS psql -h localhost -p $STA -U builder -d directus < images.dump.sql
PGPASSWORD=$STA_PASS psql -h localhost -p $STA -U builder -d directus < data.dump.sql

rm -v ./directus_sta_tables.sql ./images.dump.sql ./data.dump.sql

kill $PROXY_PID
