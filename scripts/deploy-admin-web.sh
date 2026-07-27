#! /bin/bash
set -Eeuo pipefail

ENV=$1

# Retrieve the build folder
artifact pull workflow admin-web-build-$ENV

# Upload objects to the bucket root
gsutil -m cp -r admin-web-build-$ENV/* gs://btv-admin-web-$ENV-2

# Avoid cache on the SPA shell and the Nuxt app manifest (new-build detection)
gsutil setmeta -h "Cache-Control:max-age=60,must-revalidate" \
  gs://btv-admin-web-$ENV-2/index.html \
  gs://btv-admin-web-$ENV-2/200.html \
  gs://btv-admin-web-$ENV-2/404.html \
  gs://btv-admin-web-$ENV-2/_nuxt/builds/latest.json
