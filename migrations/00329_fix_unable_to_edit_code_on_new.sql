-- +goose Up
UPDATE "public"."directus_fields" SET "options" = '{"trim":true}', "readonly" = false, "conditions" = '[{"name":"Disallow editing code later","rule":{"_and":[{"date_created":{"_gt":"1500-06-11T12:00:00+02:00"}}]},"readonly":true}]' WHERE "id" = 321;

-- +goose Down
UPDATE "public"."directus_fields" SET "options" = NULL, "readonly" = true, "conditions" = NULL WHERE "id" = 321;
