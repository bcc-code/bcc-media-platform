
# Migrations
`migrate create -ext sql -dir db/migrations name`
`migrate -database "$(cat config.json | jq '.database')"`