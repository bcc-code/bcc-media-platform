#! /bin/bash
set -euf -o pipefail
shopt -s extglob

## IF YOU CHANGE THIS YOU ALSO NEED TO CHANGE ./pg-diff-config.json
ACTIVEDB=btv
TEMPDB=btv_temp

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)
cd $script_dir

## Include PGPASSWORD if not set
if [ -z "${PGPASSWORD:-}" ] && [ -f "$script_dir/.env" ]; then
	set -o allexport
	echo "Sourcing .env"
	source $script_dir/.env
fi

## Validate that it actually worked to prevent weird errors
if [ -z "${PGPASSWORD:-}" ]; then
	echo "Please set \$PGPASSWORD. '.env' file is supported"
	exit 1
fi

## RESET THE TEMPDB
psql -h localhost -U btv -c "DROP DATABASE IF EXISTS $TEMPDB"
psql -h localhost -U btv -c "CREATE DATABASE $TEMPDB"

## RUN EXISTING MIGRATIONS ON TEMP DB
goose postgres "postgres://btv@localhost:5432/${TEMPDB}?sslmode=disable" up

## COMPARE UP
pg-diff -c up temp_up
UP=$(find . -maxdepth 1 -type f -name \*temp_up.sql)

## COMPARE DOWN
pg-diff -c down temp_down
DOWN=$(find . -maxdepth 1 -type f -name \*temp_down.sql)

## NO FILES GENERATED
if [ -z "${UP}" ] || [ -z "${UP}" ]; then
	echo "No differences found - No diff file generated"
	exit 0
fi

## CREATE A NEW MIGRATION AND SAVE FILENAME
MIGRATION=$(goose create test sql 2>&1 | sed --posix 's/.*: //')

## FILL THE MIGRATION FILE
echo "-- +goose Up" > $MIGRATION
cat $UP | 's/CREATE FUNCTION/-- +goose StatementBegin\nCREATE FUNCTION/' | 's/$$;/$$;\n-- +goose StatementEnd/' >> $MIGRATION
echo "-- +goose Down" >> $MIGRATION
cat $DOWN | 's/CREATE FUNCTION/-- +goose StatementBegin\nCREATE FUNCTION/' | 's/$$;/$$;\n-- +goose StatementEnd/' >> $MIGRATION

echo Cleanup
rm -v $UP $DOWN

echo "Note: If you have things like triggers you may need to add"
echo "-- +goose statementStart"
echo "-- +goose statmmentEnd"
echo "instructions around it. Try runnig the script again and if you get an error it is most likely the reason"
