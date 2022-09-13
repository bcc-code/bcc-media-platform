
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

