.PHONY: show update-types

update-types:
	npx directus-typescript-gen --host $DU_HOST --email $DU_AMDIN_EMAIL --password $DU_ADMIN_PASS --typeName BTVTypes --outFile types.d.ts

series:
	npx ts-node series.ts
