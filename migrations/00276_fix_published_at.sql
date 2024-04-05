-- +goose Up
UPDATE "public"."directus_fields"
SET "special" = NULL
WHERE "id" = 1458;


-- +goose Down
UPDATE "public"."directus_fields"
SET "special" = 'date-created'
WHERE "id" = 1458;
