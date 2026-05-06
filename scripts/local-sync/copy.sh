#! /bin/bash
#
# set -x

read -p "Are you sure? This *WILL* destroy any data in LOCAL!" -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1 # handle exits from shell or function but don't exit interactive shell
fi

PROD=15432
STA=5432

PROD_PASS=$(gcloud --project=btv-platform-prod-2 secrets versions access latest --secret="postgres_builder_password")

# Add for dev:
# btv-platform-dev-2:europe-west4:main-instance (add as another positional arg, with --port $DEV)

cloud-sql-proxy --debug-logs --port $PROD btv-platform-prod-2:europe-west4:main-instance &
PROXY_PID=$!

# Wait for the proxy to connect
sleep 3

PGPASSWORD=$PROD_PASS pg_dump -h localhost -p $PROD -U builder -d directus -v -c --if-exists --table public.directus_* --schema public > directus_sta_tables.sql

PGPASSWORD=$PROD_PASS pg_dump -h localhost -p $PROD -U builder -d directus -v -c --if-exists --exclude-table public.directus_* --schema public > data.dump.sql

PGPASSWORD=$PROD_PASS pg_dump -h localhost -p $PROD -U builder -d directus -v -c --if-exists --table public.directus_files --schema public > images.dump.sql

PGPASSWORD=$PROD_PASS pg_dump -h localhost -p $PROD -U builder -d directus --schema-only -v -c --if-exists --schema users > users_schema.dump.sql

PGPASSWORD=bccm123 psql -h localhost -p $STA -U bccm -d bccm < drop-schema.sql
PGPASSWORD=bccm123 psql -h localhost -p $STA -U bccm -d bccm < directus_sta_tables.sql
PGPASSWORD=bccm123 psql -h localhost -p $STA -U bccm -d bccm < images.dump.sql
PGPASSWORD=bccm123 psql -h localhost -p $STA -U bccm -d bccm < data.dump.sql
PGPASSWORD=bccm123 psql -h localhost -p $STA -U bccm -d bccm < users_schema.dump.sql

rm -v ./directus_sta_tables.sql ./images.dump.sql ./data.dump.sql ./users_schema.dump.sql

kill $PROXY_PID
