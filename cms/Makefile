
.PHONY: schema-update
schema-update:
	yq e '.collections.[].meta.group = null' schema.yml > temp.yml
	npx directus schema apply temp.yml -y
	npx directus schema apply schema.yml -y
	rm temp.yml