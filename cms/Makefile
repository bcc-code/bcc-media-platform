.PHONY: run init reset s

install:
	npm ci
	cd ./custom && make install

build:
	rm -rf ./extensions
	npm run build
	cd ./custom && make build

s:
	make build
	docker-compose up -d
	npx directus start

init:
	-cp -n .template.env .env
	npm i
	rm -rf ./extensions
	npm run build
	cd ./custom && make init

reset:
	docker compose down -v
	make init

run:
	npx directus start

generate-types:
	npx directus-typescript-gen --host http://localhost:8055 --email admin@brunstad.tv --password btv123 --typeName episodes --outFile types/btv.d.ts

setup-macos:
	brew install libpq
