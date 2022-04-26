
# BrunstadTV Admin

## Local setup

First you need to create a localized version of `.template.env` file.
```
npm i
docker compose up -d
npx directus bootstrap
make schema-update
```

## Starting locally

You can start a local instance (after completing the above section) using `make run`

The initial credentials are:

Username: admin@brunstad.tv
Pass: btv123


## Issues

###  Snapshots and apply

`schema apply` has some issues with foreign keys: https://github.com/directus/directus/issues/9723

To fix this, we create a temporary schema with the relations removed, then apply the original schema.
We do this in the make schema-update script.

You can install yq using `go install github.com/mikefarah/yq/v4@latest`

```
yq e '.collections.[].meta.group = null' schema.yml > temp.yml
npx directus schema apply temp.yml -y
npx directus schema apply schema.yml -y
```
