
# BrunstadTV CMS

# Local setup

## Prerequisities

You need:
- docker
- npm

If using windows (without wsl), you also need:
- make for windows ([choco](https://chocolatey.org/install) install make)
- some bash terminal, like git-bash

## Setup

Run `make init`, which sets up the database and migrates it to the latest version.

Tip: You can quickly destroy your local db and run migrations again with `make reset`.

## Start the cms

You can start a local instance (after completing the above section) using `make run`

The initial login credentials are:

Username: admin@brunstad.tv
Pass: btv123

# Issues

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
