SHELL := /bin/bash

.PHONY: run init reset s


# A macro to loop over directories with package.json
RUN_IN_DIRS = \
	for dir in extensions/*/; do \
		if [ -f "$$dir/package.json" ]; then \
			( cd $$dir && $(1) ); \
		fi \
	done

# nvm setup must run in the SAME shell as the command that uses it; each make
# recipe line is a separate shell, so chain with ';\' below.
NVM_LOAD = [ -s "$$NVM_DIR/nvm.sh" ] && . "$$NVM_DIR/nvm.sh" && nvm use || echo "WARNING: nvm not found, not switching Node version"

run:
	$(NVM_LOAD); \
	npx directus start

install:
	$(NVM_LOAD); \
	pnpm i; \
	$(call RUN_IN_DIRS, pnpm i)

update:
	$(NVM_LOAD); \
	pnpm update --latest; \
	$(call RUN_IN_DIRS, pnpm update --latest)

build:
	$(NVM_LOAD); \
	$(call RUN_IN_DIRS, pnpm build)

init:
	make install
	make build

reset:
	make init

generate-types:
	npx directus-typescript-gen --host http://localhost:8055 --email admin@brunstad.tv --password btv123 --typeName episodes --outFile src/btv.d.ts

setup-macos:
	brew install libpq
