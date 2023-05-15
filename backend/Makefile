SHELL=/bin/bash

# define standard colors
ifneq (,$(findstring xterm,${TERM}))
	YELLOW       := $(shell tput -Txterm setaf 3)
	RESET 		 := $(shell tput -Txterm sgr0)
else
	YELLOW       := ""
endif
.PHONY: sqlc

build: dist/api dist/jobs dist/pubsub-helper

dist/api dist/jobs dist/pubsub-helper: ./**/*.go sqlc/.generated
	CGO_ENABLED=0 go build -v -o $@ ./cmd/$(@F)

sqlc/.generated: ../migrations/*.sql
	@sqlc generate || (printf "${YELLOW}Are you missing sqlc? Install it, e.g. with brew install sqlc.${RESET}\n" && false)
	touch .generated

run:
	@echo "No 'run'. Did you mean 'run-api'?"

install-dep-macos:
	brew install sqlc

gql.api:
	cd graph/api && go run github.com/99designs/gqlgen

gql.public:
	cd graph/public && go run github.com/99designs/gqlgen

gql.admin:
	cd graph/admin && go run github.com/99designs/gqlgen

gql: gql.api gql.public gql.admin

topic.create:
	go run ./cmd/pubsub-helper -task create -host localhost:8681

topic.delete:
	go run ./cmd/pubsub-helper -task delete -host localhost:8681

event.search.reindex:
	go run ./cmd/pubsub-helper -task searchReindex -host localhost:8681

event.translations.sync:
	go run ./cmd/pubsub-helper -task syncTranslations -host localhost:8681

run-api: dist/api
	@cp -n ./cmd/api/env.sample ./cmd/api/.env || true
	@printf "${YELLOW}Running the API.\nRemember to update ./cmd/api/.env with proper values!${RESET}\n\n\n"
	go run github.com/joho/godotenv/cmd/godotenv@latest -f ./cmd/api/.env dist/api

test.integration:
	docker rm -f redis-integration-test
	docker run --name redis-integration-test -d -p 6999:6379 redis
	export REDIS_ADDRESS=localhost:6999 && go test ./... -tags=integration
	docker rm -f redis-integration-test
