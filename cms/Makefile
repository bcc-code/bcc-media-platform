.PHONY: run init reset s

run:
	npx directus start

install:
	npm ci
	cd ./custom && make install

build:
	rm -rf ./extensions
	npm run build
	cd ./custom && make build

init:
	make install
	make build
	cd ./custom && make init

reset:
	make init

generate-types:
	npx directus-typescript-gen --host http://localhost:8055 --email admin@brunstad.tv --password btv123 --typeName episodes --outFile types/btv.d.ts

setup-macos:
	brew install libpq
