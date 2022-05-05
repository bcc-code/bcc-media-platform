
update-schema:
	get-graphql-schema -h "Authorization=Bearer jsdlkgjlkrjglkdsjrglkdxrjglksdjrglksjdrlgkjsdlrkgjsdlkrgjsdlrkjglsdkrg" http://localhost:8055/graphql > directus/schema.graphql
	cd directus && go run github.com/Khan/genqlient
