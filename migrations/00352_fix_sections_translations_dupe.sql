-- +goose Up
UPDATE "public"."directus_fields"
SET "options" = '{"defaultLanguage":"no","languageField":"code","userLanguage":false}'::json
WHERE "id" = 247;

-- +goose Down
UPDATE "public"."directus_fields"
SET "options" = '{"defaultLanguage":"no","languageField":"code","userLanguage":true}'::json
WHERE "id" = 247;
