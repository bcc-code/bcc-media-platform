#!/bin/bash
while getopts h:p:U:P:d: flag
do
    case "${flag}" in
        h) HOST=${OPTARG};;
        p) PORT=${OPTARG};;
        U) USERNAME=${OPTARG};;
        P) PASSWORD=${OPTARG};;
        d) DATABASE=${OPTARG};;
    esac
done

set -euf -o pipefail
shopt -s extglob
trap cleanup SIGINT SIGTERM ERR

cleanup() {
  trap - SIGINT SIGTERM ERR
  echo "Cleanup" # make sure we don't just hang
  kill ${PROXY_PID:-} > /dev/null 2>&1;
  exit 1
}

GOOSE=$(which goose || echo "/bin/goose")

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)
cd $script_dir

psql -h $HOST -p $PORT -U $USERNAME $DATABASE < ./special/00-reset.sql
$GOOSE postgres "user=$USERNAME dbname=$DATABASE port=$PORT host=$HOST sslmode=disable" up
psql -h $HOST -p $PORT -U $USERNAME $DATABASE < ./special/01-admin-user.sql
