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

topic.create:
	go run ./cmd/pubsub-helper -task create

topic.delete:
	go run ./cmd/pubsub-helper -task delete

event.search.reindex:
	go run ./cmd/pubsub-helper -task searchReindex

event.translations.sync:
	go run ./cmd/pubsub-helper -task syncTranslations
