#! /bin/bash

cd ./web

pnpm i
pnpm revision

pnpm build:dev
mv build build-dev

pnpm build:sta
mv build build-sta

pnpm build:prod
mv build build-prod

artifact push workflow build-dev
artifact push workflow build-sta
artifact push workflow build-prod
