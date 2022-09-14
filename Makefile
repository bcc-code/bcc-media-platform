.PHONY: help

help:
	@echo "Sorry, can't help you"

background-worker-docker:
	 docker build -f ./backend/Dockerfile.background-worker -t btv-background-jobs -t "eu.gcr.io/btv-platform-dev/background-worker/background-jobs" .

release:
	./scripts/new-release.sh

install:
	docker compose up -d --wait
	cd ./migrations && PGPASSWORD=btv123 make install

init:
	docker compose up -d --wait
	cd ./cms && make init

diff:
	./scripts/db_diff.sh
	cd ./migrations && goose fix

run:
	@echo "No 'run' here. Try switching to a subfolder like 'cms' or 'backend' and doing 'make run' there."