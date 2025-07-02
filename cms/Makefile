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
	[ -s "$$NVM_DIR/nvm.sh" ] && . "$$NVM_DIR/nvm.sh" && nvm use || echo "WARNING: nvm not found, not switching Node version"
	npx directus start

install:
    [ -s "$$NVM_DIR/nvm.sh" ] && . "$$NVM_DIR/nvm.sh" && nvm use || echo "WARNING: nvm not found, not switching Node version"
	npm i
	@$(call RUN_IN_DIRS, npm i)

update:
	[ -s "$$NVM_DIR/nvm.sh" ] && . "$$NVM_DIR/nvm.sh" && nvm use || echo "WARNING: nvm not found, not switching Node version"
	npm update --latest
	@$(call RUN_IN_DIRS, npm update --latest)

build:
	[ -s "$$NVM_DIR/nvm.sh" ] && . "$$NVM_DIR/nvm.sh" && nvm use || echo "WARNING: nvm not found, not switching Node version"
	@$(call RUN_IN_DIRS, npm run build)

init:
	make install
	make build

reset:
	make init

generate-types:
	npx directus-typescript-gen --host http://localhost:8055 --email admin@brunstad.tv --password btv123 --typeName episodes --outFile src/btv.d.ts

setup-macos:
	brew install libpq
