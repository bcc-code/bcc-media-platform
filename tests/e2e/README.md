# Testing

## Setting up

Run `pnpm i` to install dependencies
Start the other necessary applications:

-   Database (in `/`: `make init`)
-   Directus
-   API

## Running

Copy `.env.example` to `.env` and change parameters to the correct ones if different,
or leave them empty to use the default values specified in [config.ts](./lib/config.ts)

Do `make test` to run the tests

### From scratch
Run `make tests.setup` in [root](../..) and `make tests.run` to run the tests on a new database.

## Types

In order to get updated typing in the test project, you might want to run `make generate-types` in [the cms directory](../../cms) (or `make types`)
