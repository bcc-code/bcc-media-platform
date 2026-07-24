#! /bin/bash
set -Eeuo pipefail

cd ./admin-web

pnpm install --frozen-lockfile

# Default apiUrl in nuxt.config.ts is the prod value (https://api.bcc.media),
# so no build-time env vars are needed for the prod build.
pnpm build
mv .output/public admin-web-build-prod

artifact push workflow admin-web-build-prod
