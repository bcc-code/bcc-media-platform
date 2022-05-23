#!/bin/sh
npx directus bootstrap
make schema-update
npx directus start
