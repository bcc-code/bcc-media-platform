# Database

## Makefile

Many of the commands are in the Makefile. For example:

```
make migrate
```

## Migrations

In order to be able to run migrations use install https://github.com/golang-migrate/migrate/tree/master/cmd/migrate

Create a new migration

```
migrate create -ext sql -seq -dir backend/db/migrations name
```

Run migrations
```
migrate -database "postgres://postgres:password@localhost:5432/vod?sslmode=disable" -path backend/db/migrations` <up|down>
```

## Mocking
- Use [mock-data](https://github.com/pivotal-gss/mock-data) (but make sure [this PR](https://github.com/pivotal-gss/mock-data/pull/46) is merged, otherwise build [the branch from our repo](https://github.com/BCC-Media/mock-data/tree/feature/custom-and-automock))
- Run: `mock custom -f db/mock/mock_skeleton.yaml --database vod -v --password password`
- Note: This removes all constraints, mocks, then recreates the constraints. It currently fails to recreate all the constraints, so keep that in mind.


# Admin API
Follows the convention defined by [ra-data-json](https://www.npmjs.com/package/ra-data-json-server).