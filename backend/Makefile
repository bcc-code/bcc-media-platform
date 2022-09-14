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
	go run ./cmd/pubsub-helper -task create -host localhost:8681

topic.delete:
	go run ./cmd/pubsub-helper -task delete -host localhost:8681

event.search.reindex:
	go run ./cmd/pubsub-helper -task searchReindex -host localhost:8681

event.translations.sync:
	go run ./cmd/pubsub-helper -task syncTranslations -host localhost:8681
