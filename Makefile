.PHONY: help

include .env
export

help:
	@echo "Sorry, can't help you"

run:
	@echo "No 'run' here. Try switching to a subfolder like 'cms' or 'backend' and doing 'make run' there."

release:
	./scripts/new-release.sh

install:
	docker compose up -d --wait
	cd ./migrations && make install

init:
	docker compose up -d --wait
	cd ./cms && make init

diff:
	./scripts/db_diff.sh $(name)

migrate.up:
	cd ./migrations && goose postgres "postgres://localhost:${PGPORT}/${PGDATABASE}?sslmode=disable" up

migrate.down:
	cd ./migrations && goose postgres "postgres://localhost:${PGPORT}/${PGDATABASE}?sslmode=disable" down

migrate.status:
	cd ./migrations && goose postgres "postgres://localhost:${PGPORT}/${PGDATABASE}?sslmode=disable" status

sync.staging:
	cd ./scripts/staging-sync/ && ./copy.sh

tests.setup:
	./scripts/tests-setup.sh

# Must be run in order to rebuild the docker images
tests.build:
	./scripts/tests-rebuild.sh

tests.rebuild:
	make tests.build && make tests.setup

tests.run:
	./scripts/tests-run.sh
