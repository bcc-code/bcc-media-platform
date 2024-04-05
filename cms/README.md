# BCC Media CMS

# Local setup

## Prerequisities

You need:

- docker
- npm

If using windows (without wsl), you also need:

- make for windows ([choco](https://chocolatey.org/install) install make)
- some bash terminal, like git-bash

## Setup

Run `make init` to build extensions and install them.

Directus has no control over migrations, so run `make init` and `make migrate.up` in `/` to set up the database.

## Start the cms

You can start a local instance (after completing the above section) using `make run`

The initial login credentials are:

Username: admin@brunstad.tv
Pass: bccm123
