.PHONY: show update-types

update-types:
	npx directus-typescript-gen --host $DU_HOST --email $DU_ADMIN_EMAIL --password $DU_ADMIN_PASS --typeName BTVTypes --outFile types.d.ts

series:
	DU_HOST="http://127.0.0.1:8055" DU_ADMIN_EMAIL=admin@brunstad.tv DU_ADMIN_PASS=btv123 npx ts-node series.ts

all:
	make series
