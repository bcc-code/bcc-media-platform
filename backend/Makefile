.PHONY: pubsub sqlc

pubsub:
	./scripts/pubsub.sh

sqlc:
	sqlc generate

install-dep-macos:
	brew install sqlc

gql:
	cd graph && gqlgen
	cd graphadmin && gqlgen
