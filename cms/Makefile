.PHONY: run init reset s

run:
	pnpm directus start

install:
	pnpm i
	cd ../packages/directus-modules && make install

update:
	pnpm update
	cd ../packages/directus-modules && make update

build:
	rm -rf ./extensions
	#npm run build
	cd ../packages/directus-modules && make build

init:
	make install
	make build

reset:
	make init

generate-types:
	npx directus-typescript-gen --host http://localhost:8055 --email admin@brunstad.tv --password btv123 --typeName episodes --outFile src/btv.d.ts

setup-macos:
	brew install libpq
