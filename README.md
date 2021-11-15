![BCC.Media logo](https://storage.googleapis.com/bcc-media-public/bcc-media-logo-150.png)

# BrunstadTV Backend (In development)



## Getting started

### Prerequisites

- Backend: Docker, go
- Frontend: pnpm

### First steps

- Run `docker-compose up` in the repository root folder. This sets up a postgres database and Typesense.
- Open the go project at `backend/admin/` (or run `make run-admin-backend`)
- Open `frontend` and run `pnpm install` and `pnpm start`

## More details
### Database
#### Migrations

In order to be able to run migrations install this: https://github.com/golang-migrate/migrate/tree/master/cmd/migrate

Create a new migration

```
migrate create -ext sql -seq -dir backend/db/migrations name
```

Run migrations
```
migrate -database "postgres://postgres:password@localhost:5432/postgres?sslmode=disable" -path backend/db/migrations` <up|down>
```

#### Mocking
- Use [mock-data](https://github.com/pivotal-gss/mock-data) (but make sure [this PR](https://github.com/pivotal-gss/mock-data/pull/46) is merged, otherwise build [the branch from our repo](https://github.com/BCC-Media/mock-data/tree/feature/custom-and-automock))
- Run: `mock custom -f db/mock/mock_skeleton.yaml --database postgres -v --password password`
- Note: This removes all constraints, mocks, then recreates the constraints. It currently fails to recreate all the constraints, so keep that in mind.

## Makefile

Many of the commands are in the Makefile. For example:

```
make migrate
make test-build
```

## Admin API
Follows the convention defined by [ra-data-json](https://www.npmjs.com/package/ra-data-json-server).