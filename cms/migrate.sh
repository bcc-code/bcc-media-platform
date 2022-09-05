#!/bin/bash

set -euf -o pipefail
shopt -s extglob
trap cleanup SIGINT SIGTERM ERR EXIT

cleanup() {
  trap - SIGINT SIGTERM ERR EXIT
  # script cleanup here

  echo "Cleanup"

  kill ${PROXY_PID:-} > /dev/null 2>&1;
}

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)
cd $script_dir

PROXY=$(which cloud_sql_proxy || echo "/cloud_sql_proxy")
GOOSE=$(which goose || echo "/bin/goose")

$PROXY -dir=./cloudsql -instances=${INSTANCE_CONNECTION_NAME}=tcp:54321 &
PROXY_PID=$!
sleep 2

ls ./cloudsql/btv-platform-dev-2:europe-west4:main-instance
cd ../migrations
$GOOSE postgres "user=$PGUSER password=$PGPASSWORD dbname=$PGDATABASE port=54321 host=localhost sslmode=disable" up
