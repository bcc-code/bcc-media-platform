.PHONY: help

include .env
export

help:
	@echo "Sorry, can't help you"

run:
	@echo "No 'run' here. Try switching to a subfolder like 'cms' or 'backend' and doing 'make run' there."

init:
	docker compose up -d --wait
	cd ./cms && make init

diff:
	@if [ -z "${name}" ]; then echo "Add a name with make diff name=migration_name_here"; exit 1; fi
	./scripts/db_diff.sh $(name)
	cd ./backend && make ./sqlc/.generated

db.init:
	./scripts/db_manage.sh

migrate.up:
	cd ./migrations && go tool goose postgres "postgres://${PGUSER}:${PGPASSWORD}@localhost:5432/${LOCALDB}?sslmode=disable" up

migrate.down:
	cd ./migrations && go tool goose postgres "postgres://${PGUSER}:${PGPASSWORD}@localhost:5432/${LOCALDB}?sslmode=disable" down

migrate.status:
	cd ./migrations && go tool goose postgres "postgres://${PGUSER}:${PGPASSWORD}@localhost:5432/${LOCALDB}?sslmode=disable" status

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

infra.dev:
	cd $(INFRA_PATH_DEV) \
		&& terragrunt init \
		&& terragrunt apply

infra.prod:
	cd $(INFRA_PATH_PROD) \
		&& terragrunt init \
		&& terragrunt apply

infra.sta:
	cd $(INFRA_PATH_STA) \
		&& terragrunt init \
		&& terragrunt apply

test.postgressservice:
	docker run --rm --name bccm-test-pg -e POSTGRES_PASSWORD=bccm123 -p 54321:5432  postgres postgres -c log_statement=all
