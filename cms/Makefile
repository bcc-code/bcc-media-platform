.PHONY: schema-update run schema-snapshot init reset s


s:
	docker-compose up -d
	npx directus start

init:
	-cp -n .template.env .env
	npm i
	docker-compose up -d
	npx directus bootstrap
	make schema-update

reset:
	docker compose down -v
	make init

run:
	npx directus start

schema-update:
	npx directus schema apply base-schema.yml -y
	npx directus schema apply schema.yml -y

schema-snapshot:
	npx directus schema snapshot schema.yml -y
	export PGPASSWORD=btv123 && pg_dump btv -h localhost -U btv --schema-only --encoding=utf8 > ../migrations/000001_schema.up.sql
	docker run --rm -v "${PWD}":/workdir mikefarah/yq e '.collections.[].meta.group = null' schema.yml > base-schema.yml

generate-types:
	npx directus-typescript-gen --host http://localhost:8055 --email admin@brunstad.tv --password btv123 --typeName episodes --outFile types/btv.d.ts

setup-macos:
	brew install libpq
