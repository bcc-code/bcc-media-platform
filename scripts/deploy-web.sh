#! /bin/bash
set -Eeuo pipefail

ENV=$1

# Retrieve the build folder
artifact pull workflow build-$ENV

# Upload objects to the bucket root
gsutil -m cp -r build-$ENV/* gs://btv-web-$ENV-2

# Avoid cache on index.html
gsutil setmeta -h "Cache-Control:max-age=60,must-revalidate" gs://btv-web-$ENV-2/index.html
