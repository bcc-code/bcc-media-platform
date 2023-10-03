#! /bin/bash
set -euf -o pipefail
shopt -s extglob

if ! command -v pg-diff &> /dev/null
then
    echo "pg-diff could not be found"
	echo "Install with: npm install -g pg-diff-cli"
    exit
fi

if ! command -v goose &> /dev/null
then
    echo "goose could not be found"
	echo "Install with: go install github.com/pressly/goose/v3/cmd/goose@latest"
    exit
fi

if ! command -v psql &> /dev/null
then
    echo "psql could not be found"
	echo "You have to have the postgresql client installed locally and in your path"
    exit
fi


if [ -z "${1:-}" ]; then
	echo "First param should be the migration name"
	exit 1
fi

MIGRATIONNAME=$1

## IF YOU CHANGE THIS YOU ALSO NEED TO CHANGE ./pg-diff-config.json
ACTIVEDB=${LOCALDB}
TEMPDB=temporary

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)
cd $script_dir/../migrations

## Include PGPASSWORD if not set
if [ -z "${PGPASSWORD:-}" ] && [ -f "$script_dir/../.env" ]; then
	set -o allexport
	echo "Sourcing .env"
	source $script_dir/../.env
fi

## Validate that it actually worked to prevent weird errors
if [ -z "${PGPASSWORD:-}" ]; then
	echo "Please set \$PGPASSWORD. '.env' file at the root of the repo is supported"
	exit 1
fi

## RESET THE TEMPDB
psql -h localhost -U ${PGUSER} -c "DROP DATABASE IF EXISTS $TEMPDB"
psql -h localhost -U ${PGUSER} -c "CREATE DATABASE $TEMPDB"

## RUN EXISTING MIGRATIONS ON TEMP DB
goose postgres "postgres://${PGUSER}@localhost:5432/${TEMPDB}?sslmode=disable" up

## COMPARE UP
pg-diff -c up temp_up
UP=$(find . -maxdepth 1 -type f -name \*temp_up.sql)

## NO FILES GENERATED
if [ -z "${UP}" ]; then
	echo "No differences found - No diff file generated"
	exit 0
fi

## COMPARE DOWN
pg-diff -c down temp_down
DOWN=$(find . -maxdepth 1 -type f -name \*temp_down.sql)

## NO FILES GENERATED
if [ -z "${DOWN}" ]; then
	echo "No differences found on DOWN. Generating an empty file"
	DOWN="temp_down.sql"
	touch $DOWN
fi

## CREATE A NEW MIGRATION AND SAVE FILENAME
MIGRATION=$(goose create "$MIGRATIONNAME" sql 2>&1 | sed 's/.*: //')

## FILL THE MIGRATION FILE
echo "-- +goose Up" > $MIGRATION
cat $UP | sed 's/CREATE FUNCTION/-- +goose StatementBegin\nCREATE FUNCTION/' | sed 's/$$;/$$;\n-- +goose StatementEnd/' >> $MIGRATION
echo "-- +goose Down" >> $MIGRATION
cat $DOWN | sed 's/CREATE FUNCTION/-- +goose StatementBegin\nCREATE FUNCTION/' | sed 's/$$;/$$;\n-- +goose StatementEnd/' >> $MIGRATION

echo Cleanup
rm -v $UP $DOWN

goose fix
cd $script_dir/../migrations
NEW_MIGRATION_NO=$(find . -maxdepth 1 -name *.sql | sort | tail -n1 | xargs basename | cut -d_ -f1)

read -p "Do you want to fake application of the latest migration (${NEW_MIGRATION_NO}) locally? " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
	echo "Ok, adding entry."
	psql -h localhost -U ${PGUSER} -c "INSERT INTO goose_db_version (version_id, is_applied, tstamp) VALUES (${NEW_MIGRATION_NO}, true, NOW());"
else
	echo "Skipping"
fi


echo "Note: If you have things like triggers you may need to add"
echo "-- +goose statementStart"
echo "-- +goose statmmentEnd"
echo "instructions around it. Try runnig the script again and if you get an error it is most likely the reason"
