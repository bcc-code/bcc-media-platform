#!/bin/sh
npx directus bootstrap
make schema-apply
npx directus start
