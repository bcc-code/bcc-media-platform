#! /bin/bash

set -euf -o pipefail

## Uncomment the following line to debug this script
# set -x

## This script is used to validate that all needed tools are installed
## and that the environment is setup correctly.

SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

ENVPATHS="${SCRIPTPATH}/../cms ${SCRIPTPATH}/../backend/cmd/api ${SCRIPTPATH}/.."
COMMANDS="cp go gum goose psql"

# Check if go is installed
if ! command -v go &> /dev/null
then
	echo "Go is not installed. Please isntall it using your package manager or from https://golang.org/dl/"
	exit 1
fi

# Check if gum is installed
if ! command -v gum &> /dev/null
then
	echo "Gum is not installed. Please isntall it using your package manager (https://github.com/charmbracelet/gum#installation) or using the following command:"
	echo "go install github.com/charmbracelet/gum@latest"
	exit 1
fi

## Check if all commands are installed
gum style --bold "Checking commands..."
for command in $COMMANDS; do
	if ! command -v $command &> /dev/null
	then
		echo ":x:  $command is not installed. Please install it" | gum format -t emoji
		exit 1
	else
		echo ":heavy_check_mark:  $command" | gum format -t emoji
	fi
done
echo

set -o allexport
source $SCRIPTPATH/../.env
set +o allexport

gum confirm "Really drop the btv database? Note that this will disconnect any connected users" && DB_RESET=true || DB_RESET=false
if [[ $DB_RESET == true ]]; then
	gum style --bold "DROP database..."

	# We need to disconnect all users before we can drop the database
	echo "SELECT pg_terminate_backend(pg_stat_activity.pid) FROM pg_stat_activity WHERE pg_stat_activity.datname = '${LOCALDB}' AND pid <> pg_backend_pid();" | psql -U btv -h localhost -d template1
	echo "DROP DATABASE IF EXISTS ${LOCALDB};" | psql -h localhost -d template1
	echo ":heavy_check_mark:  Database dropped" | gum format -t emoji
fi

for f in $(find /Users/matjaz/prog/bcc.media/brunstadtv/scripts/../migrations/special/pre -name \*.sql | sort -V); do
	gum style --foreground 212 --border-foreground 212 --border double --align center --width 100 --margin "1 1" --padding "1 1" "$(head -n1 $f | cut -c 4-)"
	gum confirm "Run ${f}?" && RUN=true || RUN=false
	if [[ $RUN == true ]]; then
		psql -h localhost -d template1 -f $f
	fi
done

gum confirm "Really create the btv database?" && RUN=true || RUN=false
if [[ $RUN == true ]]; then
	gum style --bold "Create database..."
	echo "CREATE DATABASE btv WITH OWNER = manager ENCODING = 'UTF8' CONNECTION LIMIT = -1 IS_TEMPLATE = False;" | psql -h localhost -d template1
	echo ":heavy_check_mark:  Database created" | gum format -t emoji
fi

gum confirm "Run migrations?" && RUN=true || RUN=false
if [[ $RUN == true ]]; then
	cd $SCRIPTPATH/../migrations
	goose postgres "postgres://localhost:5432/${LOCALDB}?sslmode=disable" up
	echo ":heavy_check_mark:  DB is up to date" | gum format -t emoji
	cd -
fi

for f in $(find /Users/matjaz/prog/bcc.media/brunstadtv/scripts/../migrations/special/post -name \*.sql | sort -V); do
	gum style --foreground 212 --border-foreground 212 --border double --align center --width 100 --margin "1 1" --padding "1 1" "$(head -n1 $f | cut -c 4-)"
	gum confirm "Run ${f}?" && RUN=true || RUN=false
	if [[ $RUN == true ]]; then
		psql -h localhost -d $LOCALDB -f $f
	fi
done
