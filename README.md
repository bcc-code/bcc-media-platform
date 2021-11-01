# Database
## Migrations
`migrate create -ext sql -dir db/migrations name`

`migrate -database "postgres://postgres:password@localhost:5432/vod?sslmode=disable" -path db/migrations`

## Mocking
- Use [mock-data](https://github.com/pivotal-gss/mock-data) (but make sure [this PR](https://github.com/pivotal-gss/mock-data/pull/46) is merged, otherwise build [the branch from our repo](https://github.com/BCC-Media/mock-data/tree/feature/custom-and-automock))
- Run: `mock custom -f db/mock/mock_skeleton.yaml --database vod -v --password password`
- Note: This removes all constraints, mocks, then recreates the constraints. It currently fails to recreate all the constraints, so keep that in mind.