SHELL := /bin/bash

# nvm setup must run in the SAME shell as the command that uses it; each make
# recipe line is a separate shell, so chain with ';\' below.
NVM_LOAD = [ -s "$$NVM_DIR/nvm.sh" ] && . "$$NVM_DIR/nvm.sh" && nvm use || echo "WARNING: nvm not found, not switching Node version"

run:
	$(NVM_LOAD); \
	pnpm dev

run.prod:
	$(NVM_LOAD); \
	pnpm dev:prod