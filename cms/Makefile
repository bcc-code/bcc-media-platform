.PHONY: schema-update run schema-snapshot init reset

init:
	npm i
	docker compose up -d
	npx directus bootstrap
	make schema-update

reset:
	docker compose down -v
	make init

run:
	npx directus start

schema-update:
	yq e '.collections.[].meta.group = null' schema.yml > temp.yml
	npx directus schema apply temp.yml -y
	npx directus schema apply schema.yml -y
	rm temp.yml

schema-snapshot:
	npx directus schema snapshot schema.yml -y