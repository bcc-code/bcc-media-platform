[![Build Status](https://bccmedia.semaphoreci.com/badges/brunstadtv/branches/develop.svg?style=shields&key=ca08f58c-7627-45e3-ab5e-3bfae64cc963)](https://bccmedia.semaphoreci.com/projects/brunstadtv)


# BCC Media

## Prerequisites
- `make`
- **Database**
  - `pg-diff-cli` `npm i -g pg-diff-cli`
  - Goose `go install github.com/pressly/goose/v3/cmd/goose@latest`
- **Backend**
  - Golang v1.19.0^
- **WEB**
  - NodeJS
  - PNPM
  - NPM
- **CMS**
  - NPM

## Installing

Run
```
make install
```
To install the database and run the initial migrations. This will clean the existing database if present

## Services

BCC Media is split into different services which are responsible for different parts of the application.


### [Jobs](./backend/cmd/jobs)
is an event listener hooked up to Google's PubSub. Events sent to PubSub triggers requests to endpoints on this service (in Cloud Run) which in turn do something based on the data in the event.

For example:
- Reindexing Search
- Synchronize Translations
- Update entries in respective external systems (search, crowdin)

A fake pubsub instance is run with the compose file, and is configured/triggered manually by the "commands" in the backend [Makefile](./backend/Makefile)

### [API](./backend/cmd/api)
is the public facing/open GraphQL API which an (un)authenticated user can retrieve data. It is built on the GraphQL schema files located at [graph/schema](./backend/graph/api/schema)

In most cases, this is the only backend service (in addition to a filled database/CMS) you need to run in order to get a working local environment, as this is what the frontend will exclusively communicate with.

You can start the API with `make run-api` inside the 'backend' folder. **Just remember to update the `backend/cmd/api/.env` file (run `make run-api` once and it'll make a sample one you can update.)**

#### Authentication

Authentication is implemented with [Auth0](https://auth0.com). At the moment, we use custom claims which means an Auth0 tenant and application won't work out of the box, even if the options are configured correctly in the environment here.

Additional user data is retrieved from the BCC Members API (api.bcc.no)

### [CMS](./cms)

The CMS is the system for managing the content, and is run in a separate container with Directus. This application only writes to the database and has hooks to our event service for triggering actions based on the events.

The database must be running and installed with the migrations in order for this to work. It is run with the `make run` command in the respective directory.

Setup the cms with `make init`.

The initial login credentials are:
**Username:** admin@brunstad.tv
**Pass:** btv123

### Test-data
You can quickly make some dummy data with `./packages/test-data`. Do `npm install` and `make all`.

### Formats

The default date format is RFC3339. For go: `x.Format(time.RFC3339)`

## [Testing](./tests)

Do `make tests.setup` to install dependencies and set up a testing environment.

Do `make tests.run` to run configured tests.

### [End to end](./tests/e2e)

E2E testing is written mostly in TypeScript and uses [AVA](https://github.com/avajs/ava) as the testing framework.
