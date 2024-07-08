In order to generate migration files you should have the following tools installed:

- https://michaelsogos.github.io/pg-diff/
- https://github.com/pressly/goose
- https://www.postgresql.org/docs/current/app-psql.html

Install:

```
npm install -g pg-diff-cli
go install github.com/pressly/goose/v3/cmd/goose@latest

```

`pg-diff-cli` is used for comparing the DB and generating the scripts
`goose` is used for actually running the migrations (because the other one does not support down migrations)

# Initial migrations

Make sure you have the tools above available
Run the following from this folder:

\*This WILL **_destroy_** your local DB\*

Note: Some the script can throw errors (if roles exist). This is not an issue.
Note 2: The script will appear to hang for a minute before erroring if there are other active connections to the DB!

```
make reset
```

# Generating migrations / Creating migrations

1. Do your changes to the local db. E.g. via the cms (directus).
2. Run `make diff name=your_migration_name` in the root folder of this repo. This will: 1. spin up a clean database using the current migrations, 2. do a diff with your db, 3. generate a migration.
3. Tweak the migrations. Pay special attention to:
   - Permissions (`GRANT`), as this has to be adjusted manually when you create new things. Should the background worker, api and/or directus have access to this?
   - The ordering of the statements in `off` migrations might be wrong.
   - Functions and triggers. Creating and updating them needs to be done within a statement: `-- +goose StatementBegin` / `-- +goose StatementEnd`
