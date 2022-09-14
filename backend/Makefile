SHELL=/bin/bash

# define standard colors
ifneq (,$(findstring xterm,${TERM}))
	YELLOW       := $(shell tput -Txterm setaf 3)
	RESET 		 := $(shell tput -Txterm sgr0)
else
	YELLOW       := ""
endif
.PHONY: pubsub

build: dist/api dist/jobs dist/pubsub-helper

dist/api dist/jobs dist/pubsub-helper: ./**/*.go
	CGO_ENABLED=0 go build -v -o $@ ./cmd/$(@F)

run:
	@echo "No 'run'. Did you mean 'run-api'?"

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

run-api: dist/api
	@cp -n ./cmd/api/env.sample ./cmd/api/.env || true
	@printf "${YELLOW}Running the API.\nRemember to update ./cmd/api/.env with proper values!${RESET}\n\n\n"
	go run github.com/joho/godotenv/cmd/godotenv@latest -f ./cmd/api/.env dist/api
