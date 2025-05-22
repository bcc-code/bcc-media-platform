-- +goose Up
UPDATE "public"."directus_fields" SET "options" = '{"choices":[{"text":"iOs","value":"iOS"},{"text":"tvOS","value":"tvOS"},{"text":"Android","value":"Android"},{"text":"iPadOS","value":"iPadOS"}]}' WHERE "id" = 3059;

-- +goose Down
UPDATE "public"."directus_fields" SET "options" = '{"choices":[{"text":"iOs","value":"ios"},{"text":"tvOS","value":"tvos"},{"text":"Android","value":"android"}]}' WHERE "id" = 3059;
