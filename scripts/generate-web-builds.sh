#! /bin/bash

cd ./web

pnpm i
pnpm revision

export VITE_RUDDERSTACK_WRITE_KEY=$(gcloud secrets versions access latest --secret="rudderstack_write_key" --project="btv-platform-dev-2")
export VITE_RUDDERSTACK_DATA_PLANE_URL=$(gcloud secrets versions access latest --secret="rudderstack_data_plane_url" --project="btv-platform-dev-2")
export VITE_NPAW_ACCOUNT_CODE=$(gcloud secrets versions access latest --secret="npaw_account_code" --project="btv-platform-dev-2")
pnpm build:dev
mv build build-dev

export VITE_RUDDERSTACK_WRITE_KEY=$(gcloud secrets versions access latest --secret="rudderstack_write_key" --project="btv-platform-sta-2")
export VITE_RUDDERSTACK_DATA_PLANE_URL=$(gcloud secrets versions access latest --secret="rudderstack_data_plane_url" --project="btv-platform-sta-2")
export VITE_NPAW_ACCOUNT_CODE=$(gcloud secrets versions access latest --secret="npaw_account_code" --project="btv-platform-sta-2")
pnpm build:sta
mv build build-sta

export VITE_RUDDERSTACK_WRITE_KEY=$(gcloud secrets versions access latest --secret="rudderstack_write_key" --project="btv-platform-prod-2")
export VITE_RUDDERSTACK_DATA_PLANE_URL=$(gcloud secrets versions access latest --secret="rudderstack_data_plane_url" --project="btv-platform-prod-2")
export VITE_NPAW_ACCOUNT_CODE=$(gcloud secrets versions access latest --secret="npaw_account_code" --project="btv-platform-prod-2")
pnpm build:prod
mv build build-prod

artifact push workflow build-dev
artifact push workflow build-sta
artifact push workflow build-prod
