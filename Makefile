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
	cd ./migrations && goose fix
	cd ./backend && make ./sqlc/.generated
