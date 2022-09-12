.PHONY: help init install

help:
	@echo "Run make init to get started from scratch."

background-worker-docker:
	 docker build -f ./backend/Dockerfile.background-worker -t btv-background-jobs -t "eu.gcr.io/btv-platform-dev/background-worker/background-jobs" .

release:
	./scripts/new-release.sh

install:
	cd migrations && make install
	# cd cms && make install

init:
	make install
	docker compose up -d --wait
	cd migrations && make init
	cd cms && make init