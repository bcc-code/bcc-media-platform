SHELL := /bin/bash

.PHONY: run init reset s


# A macro to loop over directories with package.json
RUN_IN_DIRS = \
	for dir in extensions/*/; do \
		if [ -f "$$dir/package.json" ]; then \
			( cd $$dir && $(1) ); \
		fi \
	done

run:
	pnpm directus start

install:
	pnpm i
	@$(call RUN_IN_DIRS, pnpm i)

update:
	pnpm update --latest
	@$(call RUN_IN_DIRS, pnpm update --latest)

build:
	@$(call RUN_IN_DIRS, pnpm build)

init:
	make install
	make build

reset:
	make init

generate-types:
	npx directus-typescript-gen --host http://localhost:8055 --email admin@brunstad.tv --password btv123 --typeName episodes --outFile src/btv.d.ts

setup-macos:
	brew install libpq
