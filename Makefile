.PHONY: help

help:
	@echo "Sorry, can't help you"

background-worker-docker:
	 docker build -f ./backend/Dockerfile.background-worker -t btv-background-jobs -t "eu.gcr.io/btv-platform-dev/background-worker/background-jobs" .

release:
	./scripts/new-release.sh

install:
	docker compose up -d --wait
	cd ./migrations && make install

init:
	docker compose up -d --wait
	cd ./cms && make init

diff:
	./scripts/db_diff.sh
	cd ./migrations && goose fix
