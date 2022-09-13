In order to generate migration files you should have the following tools installed:

* https://michaelsogos.github.io/pg-diff/
* https://github.com/pressly/goose
* https://www.postgresql.org/docs/current/app-psql.html

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

*This WILL ***destroy*** your local DB*

Note: Some statements here can throw errors (if roles exist). This is not an issue.
Note 2: The script will appear to hang for a minute before erroring if there are other active connections to the DB!

```
psql -h localhost -p 5432 -U btv postgres < ./special/00-reset.sql
goose postgres "user=builder dbname=btv port=5432 host=localhost sslmode=disable" up
psql -h localhost -p 5432 -U btv btv < ./special/01-admin-user.sql
```

