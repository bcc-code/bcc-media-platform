.PHONY: schema-update run schema-snapshot init reset s

s:
	docker-compose up -d
	npx directus start

init:
	cp -n .template.env .env
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
	docker run --rm -v "${PWD}":/workdir mikefarah/yq e '.collections.[].meta.group = null' schema.yml > temp.yml
	npx directus schema apply temp.yml -y
	npx directus schema apply schema.yml -y
	rm temp.yml

schema-snapshot:
	npx directus schema snapshot schema.yml -y

generate-types:
	npx directus-typescript-gen --host http://localhost:8055 --email admin@brunstad.tv --password btv123 --typeName episodes --outFile types/btv.d.ts
