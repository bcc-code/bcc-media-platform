#! /bin/bash
set -Eeuo pipefail

ENV=$1

cd ./web
pnpm build --mode $ENV

# Upload objects to the bucket root
gsutil -m cp -r ./build/* gs://btv-web-$ENV-2

# Avoid cache on index.html
gsutil setmeta -h "Cache-Control:no-cache" gs://btv-web-$ENV-2/index.html
