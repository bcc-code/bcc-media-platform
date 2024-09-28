SHELL := /bin/bash

# A macro to loop over directories with package.json
RUN_IN_DIRS = \
	for dir in */; do \
		if [ -f "$$dir/package.json" ]; then \
			( cd $$dir && $(1) ); \
		fi \
	done

all: # Usage: make all COMMAND="pnpm update --latest"
	@$(call RUN_IN_DIRS, $(COMMAND))

install:
	@$(call RUN_IN_DIRS, pnpm i)

build:
	@$(call RUN_IN_DIRS, pnpm build)

update:
	@$(call RUN_IN_DIRS, pnpm update --latest)

init:
	@$(MAKE) install
	@$(MAKE) build
