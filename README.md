
# Migrations
`migrate create -ext sql -dir db/migrations name`
`migrate -database "$(cat config.json | jq '.database')"`
`migrate -database "postgres://postgres:password@localhost:5432/vod?sslmode=disable" -path db/migrations`