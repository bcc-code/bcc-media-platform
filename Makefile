.PHONY: help

help:
	@echo "Sorry, can't help you"

run:
	@echo "No 'run' here. Try switching to a subfolder like 'cms' or 'backend' and doing 'make run' there."

install:
	docker compose up -d --wait
	cd ./migrations && PGPASSWORD=btv123 make install

init:
	docker compose up -d --wait
	cd ./cms && make init

diff:
	./scripts/db_diff.sh $(name)
	cd ./migrations
	cd ./backend && make ./sqlc/.generated

db.init:
	./scripts/db_manage.sh

migrate.up:
	cd ./migrations && goose postgres "postgres://btv:btv123@localhost:5432/btv?sslmode=disable" up

migrate.down:
	cd ./migrations && goose postgres "postgres://btv:btv123@localhost:5432/btv?sslmode=disable" down

migrate.status:
	cd ./migrations && goose postgres "postgres://btv:btv123@localhost:5432/btv?sslmode=disable" status

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
