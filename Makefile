.PHONY: help

help:
	@echo "Sorry, can't help you"

run:
	@echo "No 'run' here. Try switching to a subfolder like 'cms' or 'backend' and doing 'make run' there."

release:
	./scripts/new-release.sh

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

tests.run:
	./scripts/tests-run.sh
