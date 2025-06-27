-- +goose Up
UPDATE "public"."directus_fields" SET "hidden" = false WHERE "id" = 298;

-- +goose Down
UPDATE "public"."directus_fields" SET "hidden" = true WHERE "id" = 298;

