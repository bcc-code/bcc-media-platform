-- +goose Up

UPDATE "public"."directus_fields" SET "options" = '{"choices":[{"text":"Song","value":"song"},{"text":"Sing along","value":"sing_along"},{"text":"Speech","value":"speech"},{"text":"Testimony","value":"testimony"},{"text":"Appeal","value":"appeal"},{"text":"Panel","value":"panel"},{"text":"Theme","value":"theme"}]}' WHERE "id" = 1299;

-- +goose Down

UPDATE "public"."directus_fields" SET "options" = '{"choices":[{"text":"Song","value":"song"},{"text":"Sing along","value":"sing_along"},{"text":"Speech","value":"speech"},{"text":"Testimony","value":"testimony"},{"text":"Appeal","value":"appeal"}]}' WHERE "id" = 1299;
